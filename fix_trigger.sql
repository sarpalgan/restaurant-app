-- Run this in the Supabase SQL Editor to fix the trigger

-- Fix the generate_restaurant_slug function
CREATE OR REPLACE FUNCTION generate_restaurant_slug(restaurant_name TEXT)
RETURNS TEXT AS $$
DECLARE
    base_slug TEXT;
    final_slug TEXT;
    counter INTEGER := 0;
BEGIN
    -- Convert to lowercase, replace spaces with hyphens, remove special chars
    base_slug := lower(regexp_replace(restaurant_name, '[^a-zA-Z0-9\s]', '', 'g'));
    base_slug := regexp_replace(base_slug, '\s+', '-', 'g');
    base_slug := regexp_replace(base_slug, '-+', '-', 'g');
    base_slug := trim(both '-' from base_slug);
    
    -- If empty, use a default
    IF base_slug = '' OR base_slug IS NULL THEN
        base_slug := 'restaurant';
    END IF;
    
    final_slug := base_slug;
    
    -- Check for uniqueness and append number if needed
    WHILE EXISTS (SELECT 1 FROM public.restaurants WHERE slug = final_slug) LOOP
        counter := counter + 1;
        final_slug := base_slug || '-' || counter::TEXT;
    END LOOP;
    
    RETURN final_slug;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fix the handle_new_user function with better error handling
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    restaurant_name TEXT;
    restaurant_slug TEXT;
    new_restaurant_id UUID;
BEGIN
    -- Get restaurant name from user metadata, default to email-based name
    restaurant_name := COALESCE(
        NEW.raw_user_meta_data->>'restaurant_name',
        split_part(NEW.email, '@', 1) || ' Restaurant'
    );
    
    -- Generate unique slug
    restaurant_slug := generate_restaurant_slug(restaurant_name);
    
    -- Create the restaurant
    INSERT INTO public.restaurants (owner_id, name, slug)
    VALUES (NEW.id, restaurant_name, restaurant_slug)
    RETURNING id INTO new_restaurant_id;
    
    -- Create default subscription
    INSERT INTO public.subscriptions (restaurant_id, tier, status, video_credits_remaining)
    VALUES (new_restaurant_id, 'starter', 'active', 5);
    
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error but don't fail user creation
        RAISE WARNING 'handle_new_user failed: %', SQLERRM;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION generate_restaurant_slug(TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION handle_new_user() TO service_role;
GRANT EXECUTE ON FUNCTION generate_restaurant_slug(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION handle_new_user() TO authenticated;
