// supabase/functions/create-payment-intent/index.ts
// Stripe Connect payment processing for FoodArt
// Creates payment intents with destination charges (2.5% platform fee)

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@14.21.0?target=deno'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface PaymentRequest {
  orderId: string
  customerId?: string // Optional for guest checkout
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const stripeKey = Deno.env.get('STRIPE_SECRET_KEY')
    if (!stripeKey) {
      throw new Error('Stripe secret key not configured')
    }

    const stripe = new Stripe(stripeKey, {
      apiVersion: '2023-10-16',
    })

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    const { orderId, customerId } = await req.json() as PaymentRequest

    if (!orderId) {
      throw new Error('Order ID is required')
    }

    // Fetch order details with restaurant info
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .select(`
        *,
        restaurants!inner(
          id,
          name,
          stripe_account_id,
          stripe_account_status
        )
      `)
      .eq('id', orderId)
      .single()

    if (orderError || !order) {
      throw new Error('Order not found')
    }

    if (order.payment_status === 'paid') {
      throw new Error('Order already paid')
    }

    const restaurant = order.restaurants
    if (!restaurant.stripe_account_id) {
      throw new Error('Restaurant has not connected Stripe')
    }

    if (restaurant.stripe_account_status !== 'active') {
      throw new Error('Restaurant Stripe account is not active')
    }

    // Calculate amounts in cents
    const totalAmount = Math.round(order.total * 100)
    const platformFee = Math.round(totalAmount * 0.025) // 2.5% platform fee

    // Create payment intent with destination charge
    const paymentIntent = await stripe.paymentIntents.create({
      amount: totalAmount,
      currency: 'usd', // TODO: Get from restaurant settings
      application_fee_amount: platformFee,
      transfer_data: {
        destination: restaurant.stripe_account_id,
      },
      metadata: {
        order_id: orderId,
        restaurant_id: restaurant.id,
        restaurant_name: restaurant.name,
        order_number: order.order_number,
      },
      automatic_payment_methods: {
        enabled: true,
      },
      description: `Order #${order.order_number} at ${restaurant.name}`,
    })

    // Update order with payment intent ID
    await supabase
      .from('orders')
      .update({
        stripe_payment_intent_id: paymentIntent.id,
        payment_method: 'stripe',
      })
      .eq('id', orderId)

    return new Response(
      JSON.stringify({
        success: true,
        clientSecret: paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id,
        publishableKey: Deno.env.get('STRIPE_PUBLISHABLE_KEY'),
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Payment intent creation error:', error)
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})
