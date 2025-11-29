// Follow Deno Edge Function conventions
// deno-lint-ignore-file

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const KIE_API_URL = 'https://api.kie.ai/api/v1/veo'

interface VideoGenerationRequest {
  menuItemId: string
  imageUrl: string
  prompt?: string
  model?: 'veo3' | 'veo3_fast'
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    })
  }

  try {
    // Verify authentication
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Create Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: { headers: { Authorization: authHeader } },
      }
    )

    // Get user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Parse request body
    const body: VideoGenerationRequest = await req.json()
    const { menuItemId, imageUrl, prompt, model = 'veo3' } = body

    if (!menuItemId || !imageUrl) {
      return new Response(JSON.stringify({ error: 'Missing required fields' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Check if menu item exists and user has access
    const { data: menuItem, error: menuError } = await supabaseClient
      .from('menu_items')
      .select(`
        id,
        menu_categories!inner(
          restaurant_id,
          restaurants!inner(owner_id)
        )
      `)
      .eq('id', menuItemId)
      .single()

    if (menuError || !menuItem) {
      return new Response(JSON.stringify({ error: 'Menu item not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Verify ownership
    const restaurantOwnerId = menuItem.menu_categories.restaurants.owner_id
    if (restaurantOwnerId !== user.id) {
      return new Response(JSON.stringify({ error: 'Access denied' }), {
        status: 403,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Get KIE API key from environment
    const kieApiKey = Deno.env.get('KIE_API_KEY')
    if (!kieApiKey) {
      return new Response(JSON.stringify({ error: 'Video service not configured' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Create video generation job in database
    const { data: job, error: jobError } = await supabaseClient
      .from('video_generation_jobs')
      .insert({
        menu_item_id: menuItemId,
        source_image_url: imageUrl,
        status: 'pending',
        cost: 2.00, // $2 per video
      })
      .select()
      .single()

    if (jobError) {
      return new Response(JSON.stringify({ error: 'Failed to create job' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Start video generation with Kie.ai
    const videoPrompt = prompt || 'Create a captivating short video showcasing this delicious dish with subtle motion, steam effects, and appetizing presentation that makes viewers hungry'

    const kieResponse = await fetch(`${KIE_API_URL}/generate`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${kieApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        image_url: imageUrl,
        prompt: videoPrompt,
        model: model,
        duration: 5,
        aspect_ratio: '16:9',
      }),
    })

    if (!kieResponse.ok) {
      const errorText = await kieResponse.text()
      
      // Update job status to failed
      await supabaseClient
        .from('video_generation_jobs')
        .update({ status: 'failed', error_message: errorText })
        .eq('id', job.id)

      return new Response(JSON.stringify({ error: 'Failed to start video generation' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const kieData = await kieResponse.json()
    const taskId = kieData.task_id

    // Update job with external task ID
    await supabaseClient
      .from('video_generation_jobs')
      .update({
        status: 'processing',
        external_job_id: taskId,
      })
      .eq('id', job.id)

    return new Response(
      JSON.stringify({
        jobId: job.id,
        taskId: taskId,
        status: 'processing',
        message: 'Video generation started. Check back in 2-3 minutes.',
      }),
      {
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      }
    )

  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ error: error.message || 'Internal server error' }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    )
  }
})
