# FoodArt - Multilingual Restaurant Menu App

## Executive Summary

**FoodArt** is a SaaS platform that enables restaurants to digitize their menus with AI-generated food videos, accessible via QR codes. Customers scan a table-specific QR code to view an interactive menu, order food, and pay—all from their browser. Restaurant owners manage everything through a mobile admin app.

**Customer Web URL:** `https://menu.foodart.com/{restaurant_slug}/{table_id}`

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SUPABASE BACKEND                                │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌──────────────────────────┐  │
│  │ PostgreSQL │ │    Auth    │ │  Realtime  │ │     Edge Functions       │  │
│  │   + RLS    │ │            │ │            │ │ (Video Gen, Analytics)   │  │
│  └────────────┘ └────────────┘ └────────────┘ └──────────────────────────┘  │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │                    Storage (Food Images, AI Videos)                    │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
              ┌───────────────────────┴───────────────────────┐
              │                                               │
     ┌────────▼────────┐                            ┌────────▼────────┐
     │   ADMIN APP     │                            │  CUSTOMER WEB   │
     │  (Flutter Mobile)│                           │  (Flutter Web)  │
     ├─────────────────┤                            ├─────────────────┤
     │ • iOS / Android │                            │ • Browser Only  │
     │ • Full Auth     │                            │ • No Login Req  │
     │ • Menu CRUD     │                            │ • Via QR Code   │
     │ • Order Mgmt    │                            │ • Order & Pay   │
     │ • Analytics     │                            │ • Multi-lang    │
     │ • Stripe Setup  │                            │ • Real-time     │
     └─────────────────┘                            └─────────────────┘
```

---

## Tech Stack

| Component | Technology | Notes |
|-----------|------------|-------|
| **Mobile Admin** | Flutter 3.38+ (iOS/Android) | Single codebase |
| **Customer Web** | Flutter Web | Shared code with admin |
| **Backend** | Supabase | PostgreSQL, Auth, Realtime, Edge Functions, Storage |
| **State Management** | Riverpod | Modern, testable state management |
| **Authentication** | Supabase Auth | Magic link + social login |
| **Payments** | Stripe Connect | SaaS billing + customer payments |
| **AI Video** | Google Veo 3.1 (Gemini API) | Image-to-video generation |
| **QR Generation** | qr_flutter | Dynamic QR codes per table |
| **Localization** | flutter_localizations | 8 languages |

---

## Supabase Configuration

**Project URL:** `https://redqmvgcsxzytqaflclh.supabase.co`
**Publishable Key:** `sb_publishable_a8jck92aUmK4uPhcNBYQsg_PwL7fWH0`

**Required Setup:**
1. ✅ Publishable key configured
2. Configure Auth redirect URLs for deep linking
3. Create storage buckets for images and videos
4. Deploy Edge Functions for video generation

---

## Database Schema

### Core Tables

```sql
-- =====================
-- ORGANIZATIONS
-- =====================

-- Restaurants (multi-tenant)
CREATE TABLE restaurants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    logo_url TEXT,
    currency TEXT DEFAULT 'USD',
    timezone TEXT DEFAULT 'UTC',
    default_language TEXT DEFAULT 'en',
    settings JSONB DEFAULT '{
        "require_order_confirmation": false,
        "allow_direct_payment": true
    }',
    stripe_account_id TEXT, -- Stripe Connect account
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Subscription & Billing
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    stripe_subscription_id TEXT,
    tier TEXT NOT NULL, -- 'starter', 'professional', 'enterprise'
    status TEXT DEFAULT 'active', -- 'active', 'past_due', 'canceled'
    video_credits_remaining INTEGER DEFAULT 0,
    current_period_start TIMESTAMPTZ,
    current_period_end TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Video Credits Transactions
CREATE TABLE video_credit_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL, -- positive = purchase, negative = usage
    description TEXT,
    stripe_invoice_id TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Branches/Locations
CREATE TABLE branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    address TEXT,
    phone TEXT,
    timezone TEXT DEFAULT 'UTC',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Tables
CREATE TABLE tables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE CASCADE,
    table_number TEXT NOT NULL,
    qr_code_url TEXT,
    capacity INTEGER DEFAULT 4,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(branch_id, table_number)
);

-- =====================
-- MENU STRUCTURE
-- =====================

-- Menu Categories
CREATE TABLE menu_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Category Translations
CREATE TABLE menu_category_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES menu_categories(id) ON DELETE CASCADE,
    language_code TEXT NOT NULL CHECK (language_code IN ('en', 'es', 'it', 'tr', 'ru', 'zh', 'de', 'fr')),
    name TEXT NOT NULL,
    description TEXT,
    UNIQUE(category_id, language_code)
);

-- Menu Items
CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES menu_categories(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    video_url TEXT,
    video_status TEXT DEFAULT 'none', -- 'none', 'processing', 'ready', 'failed'
    allergens TEXT[] DEFAULT '{}',
    dietary_tags TEXT[] DEFAULT '{}', -- 'vegetarian', 'vegan', 'gluten-free', 'halal', 'kosher'
    calories INTEGER,
    prep_time_minutes INTEGER,
    is_available BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Item Translations
CREATE TABLE menu_item_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    language_code TEXT NOT NULL CHECK (language_code IN ('en', 'es', 'it', 'tr', 'ru', 'zh', 'de', 'fr')),
    name TEXT NOT NULL,
    description TEXT,
    UNIQUE(item_id, language_code)
);

-- =====================
-- ORDERS
-- =====================

-- Customer Sessions (anonymous)
CREATE TABLE customer_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_id UUID REFERENCES tables(id),
    language_code TEXT DEFAULT 'en',
    started_at TIMESTAMPTZ DEFAULT now(),
    ended_at TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT true
);

-- Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES customer_sessions(id),
    table_id UUID REFERENCES tables(id),
    branch_id UUID REFERENCES branches(id),
    restaurant_id UUID REFERENCES restaurants(id),
    order_number SERIAL,
    status TEXT DEFAULT 'pending', 
    -- 'pending' -> 'confirmed' -> 'preparing' -> 'ready' -> 'served' -> 'completed'
    -- 'cancelled' (can happen at any stage)
    payment_status TEXT DEFAULT 'unpaid', -- 'unpaid', 'paid', 'refunded'
    payment_method TEXT, -- 'stripe', 'direct' (pay at table)
    stripe_payment_intent_id TEXT,
    subtotal DECIMAL(10,2),
    tax DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    confirmed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);

-- Order Items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id),
    quantity INTEGER DEFAULT 1,
    unit_price DECIMAL(10,2),
    special_requests TEXT,
    modifiers JSONB DEFAULT '[]'
);

-- =====================
-- ANALYTICS
-- =====================

-- Analytics Events
CREATE TABLE analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id),
    branch_id UUID,
    session_id UUID,
    event_type TEXT NOT NULL, 
    -- 'qr_scan', 'menu_view', 'category_view', 'item_view', 'video_play', 
    -- 'add_to_cart', 'remove_from_cart', 'order_placed', 'payment_completed'
    item_id UUID,
    table_id UUID,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Daily Sales Summary (materialized for performance)
CREATE TABLE daily_sales_summary (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id),
    branch_id UUID REFERENCES branches(id),
    date DATE NOT NULL,
    total_orders INTEGER DEFAULT 0,
    total_revenue DECIMAL(12,2) DEFAULT 0,
    avg_order_value DECIMAL(10,2) DEFAULT 0,
    top_items JSONB DEFAULT '[]',
    orders_by_hour JSONB DEFAULT '{}',
    UNIQUE(restaurant_id, branch_id, date)
);

-- Item Performance
CREATE TABLE item_performance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    menu_item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    views INTEGER DEFAULT 0,
    orders INTEGER DEFAULT 0,
    revenue DECIMAL(10,2) DEFAULT 0,
    UNIQUE(menu_item_id, date)
);

-- Item Correlations (for AI suggestions)
CREATE TABLE item_correlations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id),
    item_a_id UUID REFERENCES menu_items(id),
    item_b_id UUID REFERENCES menu_items(id),
    correlation_score DECIMAL(5,4),
    times_ordered_together INTEGER DEFAULT 0,
    UNIQUE(item_a_id, item_b_id)
);

-- =====================
-- VIDEO GENERATION JOBS
-- =====================

CREATE TABLE video_generation_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id),
    menu_item_id UUID REFERENCES menu_items(id),
    source_image_url TEXT NOT NULL,
    status TEXT DEFAULT 'queued', -- 'queued', 'processing', 'completed', 'failed'
    veo_operation_id TEXT, -- Google Veo operation ID
    result_video_url TEXT,
    error_message TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    completed_at TIMESTAMPTZ
);

-- =====================
-- STAFF MANAGEMENT
-- =====================

CREATE TABLE staff_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id),
    role TEXT NOT NULL, -- 'owner', 'manager', 'staff'
    branch_ids UUID[] DEFAULT '{}', -- empty = all branches
    permissions JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);
```

### Row Level Security Policies

```sql
-- Enable RLS on all tables
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE tables ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Restaurant owners/staff can manage their data
CREATE POLICY "Staff can manage restaurants"
ON restaurants FOR ALL TO authenticated
USING (
    id IN (
        SELECT restaurant_id FROM staff_members 
        WHERE user_id = auth.uid() AND is_active = true
    )
);

-- Public can view active menu items (for customer web)
CREATE POLICY "Public can view active menu items"
ON menu_items FOR SELECT TO anon
USING (is_available = true);

CREATE POLICY "Public can view active categories"
ON menu_categories FOR SELECT TO anon
USING (is_active = true);

CREATE POLICY "Public can view translations"
ON menu_item_translations FOR SELECT TO anon
USING (true);

CREATE POLICY "Public can view category translations"
ON menu_category_translations FOR SELECT TO anon
USING (true);

-- Anonymous users can create orders
CREATE POLICY "Anon can create orders"
ON orders FOR INSERT TO anon
WITH CHECK (true);

CREATE POLICY "Anon can view their session orders"
ON orders FOR SELECT TO anon
USING (session_id IN (
    SELECT id FROM customer_sessions WHERE id = session_id
));
```

---

## Pricing Model

### SaaS Subscription Tiers

| Tier | Monthly Price | Features |
|------|--------------|----------|
| **Starter** | $29/month | 1 branch, unlimited items, 5 video credits |
| **Professional** | $79/month | 5 branches, 20 video credits, analytics |
| **Enterprise** | $199/month | Unlimited branches, 50 video credits, priority support, white-label |

### Video Credits

- **Cost to generate:** $0.40 (Veo 3.1 Standard)
- **Price to customer:** $2.00 per video
- **Margin:** $1.60 (400% markup)
- Videos are on-demand, deducted from credit balance
- Additional credits can be purchased in packs (10 for $18, 50 for $80)

### Platform Transaction Fee

- **2.5% of orders** processed through Stripe
- Restaurants can also accept direct (cash/card at table) payments with no platform fee

---

## Internationalization (i18n)

### Supported Languages

| Code | Language | RTL | Notes |
|------|----------|-----|-------|
| `en` | English | No | Default |
| `es` | Spanish | No | Latin America + Spain |
| `it` | Italian | No | |
| `tr` | Turkish | No | Special characters: ş, ğ, ı, İ |
| `ru` | Russian | No | Cyrillic script |
| `zh` | Chinese (Simplified) | No | CJK characters |
| `de` | German | No | Umlauts: ä, ö, ü, ß |
| `fr` | French | No | Accents: é, è, ç |

### Translation Strategy

1. **App UI:** Flutter ARB files in `lib/l10n/`
2. **Menu Content:** Stored in database translation tables
3. **Auto-translate:** Use DeepL/Google Translate API as starting point
4. **Manual override:** Restaurant can edit translations

### Customer Language Detection

1. Check URL parameter `?lang=tr`
2. Check localStorage for saved preference
3. Check browser `Accept-Language` header
4. Fall back to restaurant's default language

---

## Customer Web Flow

### URL Structure

```
https://qrmenu.app/{restaurant_slug}/{table_id}
         │              │              │
         │              │              └── Unique table identifier
         │              └── Restaurant's unique slug
         └── App domain (choose your domain)
```

### Flow Diagram

```
┌──────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Scan QR    │────▶│  Browser Opens  │────▶│  Auto-detect    │
│    Code      │     │  Customer Web   │     │   Language      │
└──────────────┘     └─────────────────┘     └────────┬────────┘
                                                      │
┌──────────────────────────────────────────────────────┘
│
▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Create Anon    │────▶│   Show Menu     │────▶│  Customer adds  │
│   Session       │     │  with Videos    │     │  items to cart  │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
┌────────────────────────────────────────────────────────┘
│
▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Submit Order   │────▶│ Staff Confirms  │────▶│  Kitchen Preps  │
│  (if required)  │     │   (optional)    │     │     Order       │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
┌────────────────────────────────────────────────────────┘
│
▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Customer can   │────▶│  When leaving:  │────▶│  Session Ends   │
│  add more orders│     │  Pay via Stripe │     │  Table Ready    │
│  to same table  │     │  or at table    │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## Admin App Features

### 1. Authentication
- Magic link login (email)
- Social login (Google, Apple)
- Multi-factor authentication (optional)

### 2. Restaurant Setup
- Profile & branding (logo, colors)
- Branch management
- Table configuration & QR generation
- Staff invitations & roles

### 3. Menu Management
- Category CRUD with translations
- Item CRUD with:
  - Multi-language name/description
  - Price
  - Image upload
  - AI video generation (deducts credit)
  - Allergens & dietary tags
  - Availability toggle

### 4. Order Management
- Real-time order feed (Supabase Realtime)
- Order status updates
- Table status view
- Order confirmation (if enabled)
- Print/KDS integration (future)

### 5. Payment Management
- View payment history
- Close table & collect payment
- Direct payment recording
- Stripe Connect onboarding

### 6. Analytics Dashboard
- Today's revenue & orders
- Trend charts (daily/weekly/monthly)
- Top-selling items
- Table turnover rate
- Peak hours heat map
- AI-powered suggestions

### 7. Subscription & Billing
- View current plan
- Purchase video credits
- Upgrade/downgrade tier
- Billing history

---

## Stripe Integration

### SaaS Billing (for restaurants)

```dart
// Create subscription for restaurant
final subscription = await stripe.subscriptions.create(
  customer: restaurantStripeCustomerId,
  items: [
    { price: 'price_professional_monthly' }, // $79/month
    { price: 'price_video_credit', quantity: 0 }, // Metered
  ],
);
```

### Customer Payments (via Stripe Connect)

```dart
// Destination charge - customer pays, restaurant receives
final paymentIntent = await stripe.paymentIntents.create(
  amount: orderTotal,
  currency: 'usd',
  applicationFeeAmount: (orderTotal * 0.025).round(), // 2.5% platform fee
  transferData: {
    destination: restaurantStripeAccountId, // Connected account
  },
);
```

### Video Credit Purchase

```dart
// Record video credit usage for billing
await stripe.subscriptionItems.createUsageRecord(
  subscriptionItemId,
  quantity: 1,
  action: 'increment',
);
```

---

## AI Video Generation

### Integration with Kie.ai Veo 3.1 API

**API Provider:** [Kie.ai](https://kie.ai) - 25% of Google's direct pricing
**API Endpoint:** `https://api.kie.ai/api/v1/veo/generate`

```typescript
// Supabase Edge Function: generate-video
const response = await fetch('https://api.kie.ai/api/v1/veo/generate', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${Deno.env.get('KIE_API_KEY')}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    prompt: `Cinematic food video: ${itemName}. Show steam rising, 
             warm restaurant lighting, appetizing close-up, 
             slight camera movement. Professional food photography style.`,
    imageUrls: [foodImageUrl],
    model: 'veo3_fast', // or 'veo3' for quality
    aspectRatio: '16:9',
    generationType: 'FIRST_AND_LAST_FRAMES_2_VIDEO',
    callBackUrl: `${SUPABASE_URL}/functions/v1/video-callback`,
    enableTranslation: true,
  }),
});

const { data: { taskId } } = await response.json();
// Store taskId for tracking
```

### Kie.ai API Features
- **Models:** `veo3` (Quality) or `veo3_fast` (Fast & cheaper)
- **Modes:** Text-to-video, Image-to-video, First+Last frames
- **Aspect Ratios:** 16:9, 9:16, Auto
- **Callback Support:** Webhook when video is ready
- **Multilingual:** Auto-translates prompts to English

### Job Queue Flow

1. User uploads food image to Supabase Storage
2. User clicks "Generate Video" (costs 1 credit)
3. System deducts credit, creates `video_generation_job`
4. Edge Function calls Kie.ai API with callback URL
5. Kie.ai processes video, sends webhook on completion
6. Callback function updates `menu_items.video_url`
7. Admin sees "Video Ready" notification via Realtime

---

## Project Structure

```
restaurant_app/
├── pubspec.yaml
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app.dart                  # MaterialApp configuration
│   ├── config/
│   │   ├── supabase_config.dart  # Supabase initialization
│   │   ├── stripe_config.dart    # Stripe initialization
│   │   └── app_config.dart       # Environment config
│   ├── l10n/                     # Localization files
│   │   ├── app_en.arb
│   │   ├── app_es.arb
│   │   ├── app_it.arb
│   │   ├── app_tr.arb
│   │   ├── app_ru.arb
│   │   ├── app_zh.arb
│   │   ├── app_de.arb
│   │   └── app_fr.arb
│   ├── core/
│   │   ├── models/               # Shared data models
│   │   ├── services/             # API services
│   │   ├── providers/            # Riverpod providers
│   │   └── utils/                # Helpers, extensions
│   ├── features/
│   │   ├── auth/                 # Authentication
│   │   ├── restaurant/           # Restaurant management
│   │   ├── menu/                 # Menu CRUD
│   │   ├── orders/               # Order management
│   │   ├── analytics/            # Analytics dashboard
│   │   ├── billing/              # Subscription & payments
│   │   └── settings/             # App settings
│   └── customer/                 # Customer web-specific
│       ├── pages/
│       ├── widgets/
│       └── providers/
├── web/                          # Flutter web assets
├── ios/                          # iOS configuration
├── android/                      # Android configuration
├── supabase/
│   ├── migrations/               # Database migrations
│   └── functions/                # Edge Functions
│       ├── generate-video/
│       ├── stripe-webhook/
│       └── daily-analytics/
└── test/                         # Unit & widget tests
```

---

## Development Phases

### Phase 1: Foundation (Weeks 1-3)
- [x] Project structure setup
- [ ] Supabase schema deployment
- [ ] Flutter project initialization
- [ ] Supabase client configuration
- [ ] Basic authentication (email/password)
- [ ] Restaurant & branch CRUD
- [ ] Table management & QR generation

### Phase 2: Menu System (Weeks 4-5)
- [ ] Category & item CRUD
- [ ] Image upload to Supabase Storage
- [ ] Multi-language translations
- [ ] Customer web: menu display

### Phase 3: Ordering (Weeks 6-7)
- [ ] Cart functionality
- [ ] Order submission
- [ ] Real-time order feed (admin)
- [ ] Order status management
- [ ] Staff confirmation toggle

### Phase 4: Payments (Weeks 8-9)
- [ ] Stripe Connect onboarding
- [ ] Customer checkout (Stripe)
- [ ] Direct payment recording
- [ ] 2.5% platform fee collection
- [ ] Table close & payment flow

### Phase 5: AI Videos (Weeks 10-11)
- [ ] Veo 3.1 Edge Function
- [ ] Video generation job queue
- [ ] Credit system implementation
- [ ] Video playback in menu

### Phase 6: Analytics (Week 12)
- [ ] Event tracking
- [ ] Daily aggregation function
- [ ] Analytics dashboard
- [ ] AI suggestions

### Phase 7: Polish (Weeks 13-14)
- [ ] SaaS subscription tiers
- [ ] Onboarding flow
- [ ] Error handling & edge cases
- [ ] Performance optimization
- [ ] Testing & bug fixes

---

## Business Plan Summary

### Target Market
1. **Primary:** Mid-sized restaurants in tourist areas (need multilingual)
2. **Secondary:** Hotel restaurants, cafes, food courts
3. **Tertiary:** Quick-service restaurants (QSR)

### Go-to-Market Strategy
1. **Launch Market:** Turkey (home market advantage)
2. **Expand to:** Mediterranean tourism hubs (Spain, Italy, Greece)
3. **Scale to:** Global English-speaking markets

### Revenue Projections (Year 1)

| Metric | Month 6 | Month 12 |
|--------|---------|----------|
| Restaurants | 50 | 200 |
| MRR (Subscriptions) | $3,000 | $15,000 |
| Video Credits Revenue | $500 | $3,000 |
| Transaction Fees | $1,000 | $8,000 |
| **Total MRR** | **$4,500** | **$26,000** |

### Customer Acquisition
- Restaurant trade shows
- LinkedIn B2B campaigns
- Referral program (1 month free for referrer)
- Partnership with POS providers
- Content marketing (restaurant efficiency blog)

---

## Stripe Account Setup Guide

Since you don't have a Stripe account yet, here's the setup process:

### Step 1: Create Stripe Account
1. Go to [stripe.com](https://stripe.com) and sign up
2. Complete business verification (takes 1-2 days)
3. Enable Stripe Connect in Dashboard > Connect

### Step 2: Enable Connect for Platforms
1. Dashboard > Connect > Settings
2. Choose "Express" account type for restaurants
3. Set platform fees (2.5%)
4. Configure branding

### Step 3: Get API Keys
1. Dashboard > Developers > API Keys
2. Copy Publishable key (pk_live_xxx) for Flutter app
3. Copy Secret key (sk_live_xxx) for Edge Functions

### Step 4: Configure Webhooks
1. Dashboard > Developers > Webhooks
2. Add endpoint: `https://redqmvgcsxzytqaflclh.supabase.co/functions/v1/stripe-webhook`
3. Select events: `payment_intent.succeeded`, `invoice.paid`, `customer.subscription.*`

---

## API Keys Required

| Service | Key Type | Status |
|---------|----------|--------|
| Supabase | Publishable Key | ✅ `sb_publishable_a8jck92aUmK4uPhcNBYQsg_PwL7fWH0` |
| Stripe | Publishable + Secret | ⏳ Need to create account |
| Kie.ai | API Key | ⏳ Get from [kie.ai/api-key](https://kie.ai/api-key) |

---

## Next Steps

1. ✅ Supabase publishable key configured
2. ✅ App name: **FoodArt** 
3. ✅ Domain: `menu.foodart.com/{restaurant}/{table}`
4. ⏳ Create Stripe account when ready for payments
5. ⏳ Get Kie.ai API key for video generation

**Ready to start implementation!**
