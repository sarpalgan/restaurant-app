-- =====================================================================
-- MENU ITEM VARIANTS (for items with size/quantity options)
-- =====================================================================

-- Item Variants (e.g., Small/Medium/Large, 2pc/5pc/10pc)
CREATE TABLE menu_item_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    name TEXT NOT NULL, -- e.g., "Small", "Large", "2 pieces"
    price DECIMAL(10,2) NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Variant Translations
CREATE TABLE menu_item_variant_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    variant_id UUID REFERENCES menu_item_variants(id) ON DELETE CASCADE,
    language_code TEXT NOT NULL CHECK (language_code IN ('en', 'es', 'it', 'tr', 'ru', 'zh', 'de', 'fr')),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(variant_id, language_code)
);

-- Indexes
CREATE INDEX idx_menu_item_variants_item ON menu_item_variants(item_id);
CREATE INDEX idx_menu_item_variant_translations_variant ON menu_item_variant_translations(variant_id);

-- Enable RLS
ALTER TABLE menu_item_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_item_variant_translations ENABLE ROW LEVEL SECURITY;

-- RLS Policies for menu_item_variants
CREATE POLICY "Restaurant owners can manage their item variants"
    ON menu_item_variants FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM menu_items mi
            JOIN restaurants r ON r.id = mi.restaurant_id
            WHERE mi.id = menu_item_variants.item_id
            AND r.owner_id = auth.uid()
        )
    );

CREATE POLICY "Public can view available item variants"
    ON menu_item_variants FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM menu_items mi
            WHERE mi.id = menu_item_variants.item_id
            AND mi.is_available = true
        )
    );

-- RLS Policies for menu_item_variant_translations
CREATE POLICY "Restaurant owners can manage variant translations"
    ON menu_item_variant_translations FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM menu_item_variants v
            JOIN menu_items mi ON mi.id = v.item_id
            JOIN restaurants r ON r.id = mi.restaurant_id
            WHERE v.id = menu_item_variant_translations.variant_id
            AND r.owner_id = auth.uid()
        )
    );

CREATE POLICY "Public can view variant translations"
    ON menu_item_variant_translations FOR SELECT
    USING (true);

-- Trigger for updated_at
CREATE TRIGGER update_menu_item_variants_updated_at
    BEFORE UPDATE ON menu_item_variants
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
