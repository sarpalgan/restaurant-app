// Follow Deno Edge Function conventions
// deno-lint-ignore-file

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const KIE_API_URL = 'https://api.kie.ai/api/v1/veo'

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
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: { headers: { Authorization: authHeader } },
      }
    )

    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const body = await req.json()
    const { jobId } = body

    if (!jobId) {
      return new Response(JSON.stringify({ error: 'Missing jobId' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Get job from database
    const { data: job, error: jobError } = await supabaseClient
      .from('video_generation_jobs')
      .select(`
        *,
        menu_items!inner(
          id,
          menu_categories!inner(
            restaurant_id,
            restaurants!inner(owner_id)
          )
        )
      `)
      .eq('id', jobId)
      .single()

    if (jobError || !job) {
      return new Response(JSON.stringify({ error: 'Job not found' }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Verify ownership
    const restaurantOwnerId = job.menu_items.menu_categories.restaurants.owner_id
    if (restaurantOwnerId !== user.id) {
      return new Response(JSON.stringify({ error: 'Access denied' }), {
        status: 403,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // If already completed or failed, return current status
    if (job.status === 'completed' || job.status === 'failed') {
      return new Response(
        JSON.stringify({
          jobId: job.id,
          status: job.status,
          videoUrl: job.video_url,
          error: job.error_message,
        }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
        }
      )
    }

    // Check status with Kie.ai
    const kieApiKey = Deno.env.get('KIE_API_KEY')
    if (!kieApiKey) {
      return new Response(JSON.stringify({ error: 'Video service not configured' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const statusResponse = await fetch(`${KIE_API_URL}/status/${job.external_job_id}`, {
      headers: {
        'Authorization': `Bearer ${kieApiKey}`,
      },
    })

    if (!statusResponse.ok) {
      return new Response(JSON.stringify({ error: 'Failed to check status' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const statusData = await statusResponse.json()

    // Update job in database based on external status
    if (statusData.status === 'completed' && statusData.video_url) {
      await supabaseClient
        .from('video_generation_jobs')
        .update({
          status: 'completed',
          video_url: statusData.video_url,
          completed_at: new Date().toISOString(),
        })
        .eq('id', jobId)

      // Also update the menu item with the video URL
      await supabaseClient
        .from('menu_items')
        .update({ video_url: statusData.video_url })
        .eq('id', job.menu_item_id)

      return new Response(
        JSON.stringify({
          jobId: job.id,
          status: 'completed',
          videoUrl: statusData.video_url,
          progress: 100,
        }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
        }
      )
    }

    if (statusData.status === 'failed') {
      await supabaseClient
        .from('video_generation_jobs')
        .update({
          status: 'failed',
          error_message: statusData.error || 'Unknown error',
        })
        .eq('id', jobId)

      return new Response(
        JSON.stringify({
          jobId: job.id,
          status: 'failed',
          error: statusData.error || 'Video generation failed',
        }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
        }
      )
    }

    // Still processing
    return new Response(
      JSON.stringify({
        jobId: job.id,
        status: 'processing',
        progress: statusData.progress || 0,
      }),
      {
        status: 200,
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
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
