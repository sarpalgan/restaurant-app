// supabase/functions/confirm-payment/index.ts
// Webhook handler for Stripe payment confirmations

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@14.21.0?target=deno'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, stripe-signature',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const stripeKey = Deno.env.get('STRIPE_SECRET_KEY')!
    const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')!
    
    const stripe = new Stripe(stripeKey, {
      apiVersion: '2023-10-16',
    })

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    const signature = req.headers.get('stripe-signature')
    if (!signature) {
      throw new Error('No signature provided')
    }

    const body = await req.text()
    const event = stripe.webhooks.constructEvent(body, signature, webhookSecret)

    console.log('Received Stripe event:', event.type)

    switch (event.type) {
      case 'payment_intent.succeeded': {
        const paymentIntent = event.data.object
        const orderId = paymentIntent.metadata?.order_id

        if (orderId) {
          // Update order payment status
          await supabase
            .from('orders')
            .update({
              payment_status: 'paid',
              updated_at: new Date().toISOString(),
            })
            .eq('id', orderId)

          // Track analytics event
          const { data: order } = await supabase
            .from('orders')
            .select('restaurant_id, session_id, table_id, branch_id, total')
            .eq('id', orderId)
            .single()

          if (order) {
            await supabase.from('analytics_events').insert({
              restaurant_id: order.restaurant_id,
              branch_id: order.branch_id,
              session_id: order.session_id,
              table_id: order.table_id,
              event_type: 'payment_completed',
              metadata: {
                order_id: orderId,
                amount: order.total,
                payment_intent_id: paymentIntent.id,
              },
            })
          }
        }
        break
      }

      case 'payment_intent.payment_failed': {
        const paymentIntent = event.data.object
        const orderId = paymentIntent.metadata?.order_id
        
        if (orderId) {
          console.log(`Payment failed for order ${orderId}`)
          // We don't update the order status here - just log
          // The customer can retry payment
        }
        break
      }

      case 'account.updated': {
        // Restaurant Stripe Connect account updated
        const account = event.data.object
        
        // Determine account status
        let status = 'pending'
        if (account.charges_enabled && account.payouts_enabled) {
          status = 'active'
        } else if (account.requirements?.disabled_reason) {
          status = 'restricted'
        }

        await supabase
          .from('restaurants')
          .update({
            stripe_account_status: status,
            updated_at: new Date().toISOString(),
          })
          .eq('stripe_account_id', account.id)

        break
      }
    }

    return new Response(
      JSON.stringify({ received: true }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Webhook error:', error)
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})
