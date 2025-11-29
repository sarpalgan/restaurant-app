-- =====================================================================
-- FoodArt Database Schema
-- Multilingual Restaurant Menu App with AI Video Generation
-- =====================================================================

-- Enable required extensions (Supabase already has uuid-ossp in extensions schema)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;

-- =====================================================================
-- RESTAURANTS & ORGANIZATIONS
-- =====================================================================

-- Restaurants (multi-tenant, each restaurant is an organization)
CREATE TABLE restaurants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    logo_url TEXT,
    currency TEXT DEFAULT 'USD',
    timezone TEXT DEFAULT 'UTC',
    default_language TEXT DEFAULT 'en' CHECK (default_language IN ('en', 'es', 'it', 'tr', 'ru', 'zh', 'de', 'fr')),
    settings JSONB DEFAULT '{
        "require_order_confirmation": false,
        "allow_direct_payment": true,
        "auto_accept_orders": true
    }'::jsonb,
    stripe_account_id TEXT,
    stripe_account_status TEXT DEFAULT 'pending', -- 'pending', 'active', 'restricted'
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Subscriptions
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE UNIQUE,
    stripe_subscription_id TEXT,
    stripe_customer_id TEXT,
    tier TEXT NOT NULL DEFAULT 'starter' CHECK (tier IN ('starter', 'professional', 'enterprise')),
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'past_due', 'canceled', 'trialing')),
    video_credits_remaining INTEGER DEFAULT 5,
    current_period_start TIMESTAMPTZ,
    current_period_end TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Video Credit Transactions
CREATE TABLE video_credit_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL, -- positive = purchase/grant, negative = usage
    balance_after INTEGER NOT NULL,
    description TEXT,
    stripe_invoice_id TEXT,
    menu_item_id UUID, -- Reference to menu item if used for video generation
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Branches/Locations
CREATE TABLE branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    address TEXT,
    city TEXT,
    country TEXT,
    phone TEXT,
    timezone TEXT DEFAULT 'UTC',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Tables
CREATE TABLE tables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_id UUID REFERENCES branches(id) ON DELETE CASCADE,
    table_number TEXT NOT NULL,
    qr_code_url TEXT,
    capacity INTEGER DEFAULT 4,
    is_active BOOLEAN DEFAULT true,
    current_session_id UUID, -- Active customer session
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(branch_id, table_number)
);

-- Staff Members
CREATE TABLE staff_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'staff' CHECK (role IN ('owner', 'manager', 'staff')),
    branch_ids UUID[] DEFAULT '{}', -- Empty = all branches
    permissions JSONB DEFAULT '{}'::jsonb,
    is_active BOOLEAN DEFAULT true,
    invited_email TEXT,
    invited_at TIMESTAMPTZ,
    joined_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(restaurant_id, user_id)
);

-- =====================================================================
-- MENU STRUCTURE
-- =====================================================================

-- Menu Categories
CREATE TABLE menu_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    image_url TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Category Translations
CREATE TABLE menu_category_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES menu_categories(id) ON DELETE CASCADE,
    language_code TEXT NOT NULL CHECK (language_code IN ('en', 'es', 'it', 'tr', 'ru', 'zh', 'de', 'fr')),
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
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
    video_thumbnail_url TEXT,
    video_status TEXT DEFAULT 'none' CHECK (video_status IN ('none', 'queued', 'processing', 'ready', 'failed')),
    allergens TEXT[] DEFAULT '{}',
    dietary_tags TEXT[] DEFAULT '{}', -- 'vegetarian', 'vegan', 'gluten-free', 'halal', 'kosher', 'spicy'
    calories INTEGER,
    prep_time_minutes INTEGER,
    is_available BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
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
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(item_id, language_code)
);

-- =====================================================================
-- VIDEO GENERATION
-- =====================================================================

CREATE TABLE video_generation_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    source_image_url TEXT NOT NULL,
    prompt TEXT,
    status TEXT DEFAULT 'queued' CHECK (status IN ('queued', 'processing', 'completed', 'failed')),
    provider TEXT DEFAULT 'kie', -- 'kie' for Kie.ai
    provider_task_id TEXT, -- Kie.ai taskId
    result_video_url TEXT,
    result_thumbnail_url TEXT,
    error_message TEXT,
    model TEXT DEFAULT 'veo3_fast', -- 'veo3' or 'veo3_fast'
    aspect_ratio TEXT DEFAULT '16:9',
    credits_used INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT now(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);

-- =====================================================================
-- ORDERS
-- =====================================================================

-- Customer Sessions (anonymous, created when QR is scanned)
CREATE TABLE customer_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_id UUID REFERENCES tables(id) ON DELETE SET NULL,
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE SET NULL,
    language_code TEXT DEFAULT 'en',
    device_info JSONB DEFAULT '{}'::jsonb,
    started_at TIMESTAMPTZ DEFAULT now(),
    ended_at TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT true
);

-- Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number SERIAL,
    session_id UUID REFERENCES customer_sessions(id) ON DELETE SET NULL,
    table_id UUID REFERENCES tables(id) ON DELETE SET NULL,
    branch_id UUID REFERENCES branches(id) ON DELETE SET NULL,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    status TEXT DEFAULT 'pending' CHECK (status IN (
        'pending', 'confirmed', 'preparing', 'ready', 'served', 'completed', 'cancelled'
    )),
    payment_status TEXT DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'paid', 'refunded')),
    payment_method TEXT CHECK (payment_method IN ('stripe', 'direct', NULL)),
    stripe_payment_intent_id TEXT,
    subtotal DECIMAL(10,2) DEFAULT 0,
    tax DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    platform_fee DECIMAL(10,2) DEFAULT 0, -- 2.5% platform fee
    notes TEXT,
    customer_language TEXT DEFAULT 'en',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    confirmed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);

-- Order Items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id) ON DELETE SET NULL,
    item_name TEXT NOT NULL, -- Stored in case menu item is deleted
    quantity INTEGER DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    special_requests TEXT,
    modifiers JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- =====================================================================
-- ANALYTICS
-- =====================================================================

-- Analytics Events
CREATE TABLE analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    branch_id UUID,
    session_id UUID,
    table_id UUID,
    event_type TEXT NOT NULL CHECK (event_type IN (
        'qr_scan', 'menu_view', 'category_view', 'item_view', 'video_play',
        'add_to_cart', 'remove_from_cart', 'order_placed', 'order_confirmed',
        'payment_completed', 'language_changed'
    )),
    item_id UUID,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create index for faster analytics queries
CREATE INDEX idx_analytics_events_restaurant ON analytics_events(restaurant_id, created_at);
CREATE INDEX idx_analytics_events_type ON analytics_events(event_type, created_at);

-- Daily Sales Summary (aggregated for performance)
CREATE TABLE daily_sales_summary (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    branch_id UUID REFERENCES branches(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    total_orders INTEGER DEFAULT 0,
    completed_orders INTEGER DEFAULT 0,
    cancelled_orders INTEGER DEFAULT 0,
    total_revenue DECIMAL(12,2) DEFAULT 0,
    total_tax DECIMAL(12,2) DEFAULT 0,
    avg_order_value DECIMAL(10,2) DEFAULT 0,
    total_items_sold INTEGER DEFAULT 0,
    top_items JSONB DEFAULT '[]'::jsonb, -- [{item_id, name, count, revenue}]
    orders_by_hour JSONB DEFAULT '{}'::jsonb, -- {0: count, 1: count, ...}
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(restaurant_id, branch_id, date)
);

-- Item Performance (daily aggregation)
CREATE TABLE item_performance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    menu_item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    views INTEGER DEFAULT 0,
    video_plays INTEGER DEFAULT 0,
    add_to_cart_count INTEGER DEFAULT 0,
    orders INTEGER DEFAULT 0,
    quantity_sold INTEGER DEFAULT 0,
    revenue DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(menu_item_id, date)
);

-- Item Correlations (for AI-powered suggestions)
CREATE TABLE item_correlations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    item_a_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    item_b_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    correlation_score DECIMAL(5,4) DEFAULT 0,
    times_ordered_together INTEGER DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(item_a_id, item_b_id)
);

-- =====================================================================
-- INDEXES
-- =====================================================================

CREATE INDEX idx_restaurants_owner ON restaurants(owner_id);
CREATE INDEX idx_restaurants_slug ON restaurants(slug);
CREATE INDEX idx_branches_restaurant ON branches(restaurant_id);
CREATE INDEX idx_tables_branch ON tables(branch_id);
CREATE INDEX idx_menu_categories_restaurant ON menu_categories(restaurant_id);
CREATE INDEX idx_menu_items_category ON menu_items(category_id);
CREATE INDEX idx_menu_items_restaurant ON menu_items(restaurant_id);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_orders_table ON orders(table_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at);
CREATE INDEX idx_customer_sessions_table ON customer_sessions(table_id);
CREATE INDEX idx_video_jobs_status ON video_generation_jobs(status);
CREATE INDEX idx_staff_members_user ON staff_members(user_id);

-- =====================================================================
-- ROW LEVEL SECURITY
-- =====================================================================

ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE tables ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_category_translations ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_item_translations ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE video_generation_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_members ENABLE ROW LEVEL SECURITY;

-- Helper function to check if user is staff/owner of restaurant
CREATE OR REPLACE FUNCTION is_restaurant_member(restaurant_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM staff_members
        WHERE restaurant_id = restaurant_uuid
        AND user_id = auth.uid()
        AND is_active = true
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Restaurant policies
CREATE POLICY "Users can view their restaurants"
    ON restaurants FOR SELECT
    TO authenticated
    USING (is_restaurant_member(id) OR owner_id = auth.uid());

CREATE POLICY "Owners can update their restaurants"
    ON restaurants FOR UPDATE
    TO authenticated
    USING (owner_id = auth.uid());

CREATE POLICY "Users can create restaurants"
    ON restaurants FOR INSERT
    TO authenticated
    WITH CHECK (owner_id = auth.uid());

-- Branch policies
CREATE POLICY "Staff can view branches"
    ON branches FOR SELECT
    TO authenticated
    USING (is_restaurant_member(restaurant_id));

CREATE POLICY "Managers can manage branches"
    ON branches FOR ALL
    TO authenticated
    USING (is_restaurant_member(restaurant_id));

-- Menu policies (authenticated for admin, anon for customers)
CREATE POLICY "Staff can manage menu categories"
    ON menu_categories FOR ALL
    TO authenticated
    USING (is_restaurant_member(restaurant_id));

CREATE POLICY "Public can view active categories"
    ON menu_categories FOR SELECT
    TO anon
    USING (is_active = true);

CREATE POLICY "Staff can manage menu items"
    ON menu_items FOR ALL
    TO authenticated
    USING (is_restaurant_member(restaurant_id));

CREATE POLICY "Public can view available items"
    ON menu_items FOR SELECT
    TO anon
    USING (is_available = true);

-- Translation policies
CREATE POLICY "Staff can manage category translations"
    ON menu_category_translations FOR ALL
    TO authenticated
    USING (EXISTS (
        SELECT 1 FROM menu_categories mc
        WHERE mc.id = category_id AND is_restaurant_member(mc.restaurant_id)
    ));

CREATE POLICY "Public can view category translations"
    ON menu_category_translations FOR SELECT
    TO anon
    USING (true);

CREATE POLICY "Staff can manage item translations"
    ON menu_item_translations FOR ALL
    TO authenticated
    USING (EXISTS (
        SELECT 1 FROM menu_items mi
        WHERE mi.id = item_id AND is_restaurant_member(mi.restaurant_id)
    ));

CREATE POLICY "Public can view item translations"
    ON menu_item_translations FOR SELECT
    TO anon
    USING (true);

-- Order policies
CREATE POLICY "Staff can view orders"
    ON orders FOR SELECT
    TO authenticated
    USING (is_restaurant_member(restaurant_id));

CREATE POLICY "Staff can update orders"
    ON orders FOR UPDATE
    TO authenticated
    USING (is_restaurant_member(restaurant_id));

CREATE POLICY "Anyone can create orders"
    ON orders FOR INSERT
    TO anon
    WITH CHECK (true);

CREATE POLICY "Customers can view their session orders"
    ON orders FOR SELECT
    TO anon
    USING (session_id IS NOT NULL);

-- Customer session policies
CREATE POLICY "Anyone can create sessions"
    ON customer_sessions FOR INSERT
    TO anon
    WITH CHECK (true);

CREATE POLICY "Anyone can view sessions"
    ON customer_sessions FOR SELECT
    TO anon
    USING (true);

-- Table policies
CREATE POLICY "Staff can manage tables"
    ON tables FOR ALL
    TO authenticated
    USING (EXISTS (
        SELECT 1 FROM branches b
        WHERE b.id = branch_id AND is_restaurant_member(b.restaurant_id)
    ));

CREATE POLICY "Public can view active tables"
    ON tables FOR SELECT
    TO anon
    USING (is_active = true);

-- =====================================================================
-- FUNCTIONS & TRIGGERS
-- =====================================================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to tables
CREATE TRIGGER update_restaurants_updated_at
    BEFORE UPDATE ON restaurants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_branches_updated_at
    BEFORE UPDATE ON branches
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_menu_items_updated_at
    BEFORE UPDATE ON menu_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Auto-create staff member for restaurant owner
CREATE OR REPLACE FUNCTION create_owner_staff_member()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO staff_members (restaurant_id, user_id, role, is_active, joined_at)
    VALUES (NEW.id, NEW.owner_id, 'owner', true, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER create_owner_staff_on_restaurant_create
    AFTER INSERT ON restaurants
    FOR EACH ROW EXECUTE FUNCTION create_owner_staff_member();

-- Auto-create subscription for new restaurant
CREATE OR REPLACE FUNCTION create_default_subscription()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO subscriptions (restaurant_id, tier, status, video_credits_remaining)
    VALUES (NEW.id, 'starter', 'active', 5);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER create_subscription_on_restaurant_create
    AFTER INSERT ON restaurants
    FOR EACH ROW EXECUTE FUNCTION create_default_subscription();

-- Generate unique slug for restaurant
CREATE OR REPLACE FUNCTION generate_restaurant_slug()
RETURNS TRIGGER AS $$
DECLARE
    base_slug TEXT;
    new_slug TEXT;
    counter INTEGER := 0;
BEGIN
    -- Generate base slug from name
    base_slug := lower(regexp_replace(NEW.name, '[^a-zA-Z0-9]+', '-', 'g'));
    base_slug := trim(both '-' from base_slug);
    new_slug := base_slug;
    
    -- Check for uniqueness and append counter if needed
    WHILE EXISTS (SELECT 1 FROM restaurants WHERE slug = new_slug AND id != NEW.id) LOOP
        counter := counter + 1;
        new_slug := base_slug || '-' || counter;
    END LOOP;
    
    NEW.slug := new_slug;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_slug_on_restaurant_insert
    BEFORE INSERT ON restaurants
    FOR EACH ROW
    WHEN (NEW.slug IS NULL OR NEW.slug = '')
    EXECUTE FUNCTION generate_restaurant_slug();
