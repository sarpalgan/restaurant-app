-- Fix function_search_path_mutable warnings by setting search_path = '' on all functions
-- This prevents SQL injection attacks via search_path manipulation

-- 1. update_menu_templates_updated_at
CREATE OR REPLACE FUNCTION public.update_menu_templates_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $function$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$function$;

-- 2. ensure_single_active_template
CREATE OR REPLACE FUNCTION public.ensure_single_active_template()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $function$
BEGIN
  IF NEW.is_active = true THEN
    UPDATE public.menu_templates 
    SET is_active = false 
    WHERE restaurant_id = NEW.restaurant_id 
      AND id != NEW.id 
      AND is_active = true;
  END IF;
  RETURN NEW;
END;
$function$;

-- 3. update_updated_at_column
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$;

-- 4. generate_restaurant_slug (trigger version)
CREATE OR REPLACE FUNCTION public.generate_restaurant_slug()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $function$
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
    WHILE EXISTS (SELECT 1 FROM public.restaurants WHERE slug = new_slug AND id != NEW.id) LOOP
        counter := counter + 1;
        new_slug := base_slug || '-' || counter;
    END LOOP;
    
    NEW.slug := new_slug;
    RETURN NEW;
END;
$function$;

-- 5. generate_restaurant_slug (function version with parameter)
CREATE OR REPLACE FUNCTION public.generate_restaurant_slug(restaurant_name text)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
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
    IF base_slug = '' THEN
        base_slug := 'restaurant';
    END IF;
    
    final_slug := base_slug;
    
    -- Check for uniqueness and append number if needed
    WHILE EXISTS (SELECT 1 FROM public.restaurants WHERE slug = final_slug) LOOP
        counter := counter + 1;
        final_slug := base_slug || '-' || counter;
    END LOOP;
    
    RETURN final_slug;
END;
$function$;

-- 6. is_restaurant_member
CREATE OR REPLACE FUNCTION public.is_restaurant_member(restaurant_uuid uuid)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.staff_members
        WHERE restaurant_id = restaurant_uuid
        AND user_id = auth.uid()
        AND is_active = true
    );
END;
$function$;

-- 7. create_owner_staff_member
CREATE OR REPLACE FUNCTION public.create_owner_staff_member()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
BEGIN
    INSERT INTO public.staff_members (restaurant_id, user_id, role, is_active, joined_at)
    VALUES (NEW.id, NEW.owner_id, 'owner', true, now());
    RETURN NEW;
END;
$function$;

-- 8. update_updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $function$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$function$;

-- 9. create_default_subscription
CREATE OR REPLACE FUNCTION public.create_default_subscription()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
BEGIN
    INSERT INTO public.subscriptions (restaurant_id, tier, status, video_credits_remaining)
    VALUES (NEW.id, 'starter', 'active', 5);
    RETURN NEW;
END;
$function$;

-- 10. handle_new_user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
DECLARE
  new_restaurant_id uuid;
  user_email text;
  restaurant_name text;
BEGIN
  -- Get user email safely
  user_email := COALESCE(NEW.email, 'user@example.com');
  restaurant_name := COALESCE(split_part(user_email, '@', 1), 'My') || '''s Restaurant';
  
  -- Create a new restaurant for this user
  INSERT INTO public.restaurants (
    name,
    owner_id,
    email,
    default_language,
    supported_languages
  ) VALUES (
    restaurant_name,
    NEW.id,
    user_email,
    'en',
    ARRAY['en', 'tr', 'de', 'fr', 'es', 'ar', 'ru', 'zh']
  )
  RETURNING id INTO new_restaurant_id;

  -- Store restaurant_id in user metadata
  UPDATE auth.users 
  SET raw_user_meta_data = COALESCE(raw_user_meta_data, '{}'::jsonb) || jsonb_build_object('restaurant_id', new_restaurant_id::text)
  WHERE id = NEW.id;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log the error but don't fail the user creation
    RAISE WARNING 'Failed to create restaurant for user %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$function$;
