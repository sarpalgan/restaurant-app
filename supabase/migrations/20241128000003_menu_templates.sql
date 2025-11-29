-- Menu Templates table to save AI-analyzed menus for future use
CREATE TABLE IF NOT EXISTS public.menu_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id uuid REFERENCES public.restaurants(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  detected_language text,
  detected_language_name text,
  currency text,
  template_data jsonb NOT NULL, -- Stores categories and items with translations
  is_active boolean DEFAULT false, -- Which template is currently active
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.menu_templates ENABLE ROW LEVEL SECURITY;

-- RLS Policies for menu_templates
CREATE POLICY "Restaurant owners can manage their menu templates"
  ON public.menu_templates
  FOR ALL
  USING (
    restaurant_id IN (
      SELECT id FROM public.restaurants WHERE owner_id = auth.uid()
    )
  )
  WITH CHECK (
    restaurant_id IN (
      SELECT id FROM public.restaurants WHERE owner_id = auth.uid()
    )
  );

-- Index for faster queries
CREATE INDEX idx_menu_templates_restaurant ON public.menu_templates(restaurant_id);
CREATE INDEX idx_menu_templates_active ON public.menu_templates(restaurant_id, is_active) WHERE is_active = true;

-- Function to update updated_at timestamp (if not exists)
CREATE OR REPLACE FUNCTION public.update_menu_templates_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update updated_at
CREATE TRIGGER update_menu_templates_updated_at
  BEFORE UPDATE ON public.menu_templates
  FOR EACH ROW
  EXECUTE FUNCTION public.update_menu_templates_updated_at();

-- Function to ensure only one active template per restaurant
CREATE OR REPLACE FUNCTION ensure_single_active_template()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_single_active_menu_template
  BEFORE INSERT OR UPDATE ON public.menu_templates
  FOR EACH ROW
  WHEN (NEW.is_active = true)
  EXECUTE FUNCTION ensure_single_active_template();
