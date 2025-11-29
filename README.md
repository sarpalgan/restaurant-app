# 🍽️ FoodArt - Restaurant Menu Management App

A multilingual Flutter application for restaurant menu management with AI-powered video generation, QR code ordering, and analytics.

## ✨ Features

### Restaurant Admin (Mobile App)
- 📱 **Dashboard** - Real-time overview of orders, revenue, and tables
- 🍔 **Menu Management** - Create/edit categories and items with translations
- 🎬 **AI Video Generation** - Generate compelling food videos using Kie.ai Veo 3.1
- 📊 **Analytics** - Sales charts, top items, and AI-powered insights
- 📋 **Order Management** - Real-time order tracking and status updates
- 🪑 **Table Management** - QR code generation for each table
- 🌍 **8 Languages** - EN, ES, IT, TR, RU, ZH, DE, FR

### Customer (Web via QR Code)
- 📱 **Scan & Order** - Scan table QR code to view menu
- 🛒 **Cart System** - Add items, special requests, place orders
- 📍 **Order Tracking** - Real-time order status updates
- 💳 **Payment** - Stripe integration (optional)

## 🏗️ Tech Stack

- **Frontend**: Flutter 3.32+
- **State Management**: Riverpod
- **Backend**: Supabase (PostgreSQL + Auth + Storage + Edge Functions)
- **Payments**: Stripe Connect (Express accounts)
- **AI Video**: Kie.ai Veo 3.1 API
- **Routing**: go_router
- **Charts**: fl_chart
- **QR Codes**: qr_flutter

## 💰 Pricing

| Plan | Price | Features |
|------|-------|----------|
| Starter | $29/mo | 5 video credits, 1 branch, Basic analytics |
| Professional | $79/mo | 25 video credits, 3 branches, Advanced analytics |
| Enterprise | $199/mo | Unlimited videos, Unlimited branches, AI insights |

- **Video Credits**: $2 per video (Kie.ai cost: ~$0.40)
- **Platform Fee**: 2.5% on all payments

## 🚀 Getting Started

### Prerequisites
- Flutter 3.32 or higher
- Dart 3.0+
- Supabase account
- Stripe account (for payments)
- Kie.ai API key (for video generation)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-repo/foodart.git
cd foodart
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure environment**

Update `lib/core/config/app_config.dart` with your keys:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
static const String stripePublishableKey = 'YOUR_STRIPE_KEY';
```

4. **Set up Supabase**

Run the migration to create database schema:
```bash
supabase db push
```

5. **Deploy Edge Functions**
```bash
supabase functions deploy generate-video
supabase functions deploy check-video-status
supabase functions deploy create-payment-intent
supabase functions deploy confirm-payment
supabase functions deploy create-connect-account
```

6. **Set Edge Function secrets**
```bash
supabase secrets set KIE_API_KEY=your_kie_api_key
supabase secrets set STRIPE_SECRET_KEY=your_stripe_secret
supabase secrets set STRIPE_WEBHOOK_SECRET=your_webhook_secret
```

7. **Run the app**
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── app.dart                    # App widget with theming and routing
├── main.dart                   # Entry point
├── core/
│   ├── config/
│   │   └── app_config.dart     # Environment configuration
│   ├── routing/
│   │   └── app_router.dart     # go_router configuration
│   └── theme/
│       └── app_theme.dart      # Material 3 theming
├── features/
│   ├── admin/
│   │   └── presentation/
│   │       └── pages/
│   │           ├── admin_shell.dart     # Bottom navigation shell
│   │           └── dashboard_page.dart  # Dashboard
│   ├── analytics/
│   │   └── presentation/
│   │       └── pages/
│   │           └── analytics_page.dart  # Charts and insights
│   ├── auth/
│   │   ├── presentation/
│   │   │   └── pages/
│   │   │       ├── login_page.dart
│   │   │       └── register_page.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   ├── customer/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── customer_menu_page.dart        # QR menu view
│   │       │   ├── customer_cart_page.dart        # Shopping cart
│   │       │   └── customer_order_status_page.dart
│   │       └── providers/
│   │           └── cart_provider.dart
│   ├── menu/
│   │   └── presentation/
│   │       └── pages/
│   │           ├── menu_management_page.dart
│   │           └── menu_item_edit_page.dart
│   ├── orders/
│   │   └── presentation/
│   │       └── pages/
│   │           └── orders_page.dart
│   ├── settings/
│   │   └── presentation/
│   │       └── pages/
│   │           └── settings_page.dart
│   └── tables/
│       └── presentation/
│           └── pages/
│               └── tables_page.dart
├── l10n/
│   ├── app_localizations.dart    # Localization delegate
│   ├── app_en.arb                # English strings
│   ├── app_es.arb                # Spanish
│   ├── app_it.arb                # Italian
│   ├── app_tr.arb                # Turkish
│   ├── app_ru.arb                # Russian
│   ├── app_zh.arb                # Chinese
│   ├── app_de.arb                # German
│   └── app_fr.arb                # French
└── services/
    ├── analytics_service.dart
    ├── menu_service.dart
    ├── order_service.dart
    ├── restaurant_service.dart
    ├── stripe_service.dart
    └── video_generation_service.dart

supabase/
├── migrations/
│   └── 20241127000001_initial_schema.sql
└── functions/
    ├── generate-video/
    ├── check-video-status/
    ├── create-payment-intent/
    ├── confirm-payment/
    └── create-connect-account/
```

## 🔐 Database Schema

### Core Tables
- `restaurants` - Multi-tenant restaurant data
- `branches` - Physical locations
- `tables` - Table configuration with QR codes
- `staff_members` - Role-based access control

### Menu Tables
- `menu_categories` - Categories with translations
- `menu_items` - Items with prices and media
- `menu_category_translations` - i18n for categories
- `menu_item_translations` - i18n for items

### Orders
- `customer_sessions` - Anonymous customer sessions
- `orders` - Order headers with status tracking
- `order_items` - Line items with modifiers

### Analytics
- `analytics_events` - Event tracking
- `daily_sales_summary` - Aggregated daily data
- `item_performance` - Per-item analytics

### Video Generation
- `video_generation_jobs` - AI video processing queue
- `video_credit_transactions` - Credit usage tracking

## 🌐 API Integrations

### Kie.ai Veo 3.1
Generate food videos from images:
```typescript
POST https://api.kie.ai/api/v1/veo/generate
{
  "model": "veo3_fast",
  "image": "data:image/jpeg;base64,...",
  "prompt": "Close-up shot of delicious Margherita Pizza...",
  "aspectRatio": "16:9"
}
```

### Stripe Connect
- Express accounts for restaurants
- Destination charges with platform fee
- Automatic payouts

## 📱 Customer Flow

1. Customer scans QR code at table
2. Opens menu in browser (no app required)
3. Browses categories, views items with videos
4. Adds items to cart with special requests
5. Places order
6. Tracks order status in real-time
7. Pays at counter or via Stripe (restaurant setting)

## 🛠️ Development

### Generate localization files
```bash
flutter gen-l10n
```

### Build for production
```bash
flutter build web --release  # Customer web interface
flutter build apk --release  # Android admin app
flutter build ios --release  # iOS admin app
```

## 📄 License

MIT License - See LICENSE file for details.

## 🤝 Support

- Documentation: [docs.foodart.com](https://docs.foodart.com)
- Email: support@foodart.com
- Discord: [discord.gg/foodart](https://discord.gg/foodart)
