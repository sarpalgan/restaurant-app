-- =====================================================================
-- Enable RLS on tables that were missing it
-- Fixes Supabase Security Advisor errors
-- =====================================================================

-- Enable RLS on video_credit_transactions
ALTER TABLE video_credit_transactions ENABLE ROW LEVEL SECURITY;

-- Enable RLS on daily_sales_summary
ALTER TABLE daily_sales_summary ENABLE ROW LEVEL SECURITY;

-- Enable RLS on item_performance
ALTER TABLE item_performance ENABLE ROW LEVEL SECURITY;

-- Enable RLS on item_correlations
ALTER TABLE item_correlations ENABLE ROW LEVEL SECURITY;

-- =====================================================================
-- RLS POLICIES FOR video_credit_transactions
-- =====================================================================

-- Restaurant owners can view their own credit transactions
CREATE POLICY "Restaurant owners can view their credit transactions"
    ON video_credit_transactions FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM restaurants r
            WHERE r.id = video_credit_transactions.restaurant_id
            AND r.owner_id = auth.uid()
        )
    );

-- Only system/service can insert credit transactions (via service role)
-- Users cannot directly insert credit transactions

-- =====================================================================
-- RLS POLICIES FOR daily_sales_summary
-- =====================================================================

-- Restaurant owners can view their own sales summaries
CREATE POLICY "Restaurant owners can view their sales summaries"
    ON daily_sales_summary FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM restaurants r
            WHERE r.id = daily_sales_summary.restaurant_id
            AND r.owner_id = auth.uid()
        )
    );

-- Restaurant owners can manage their sales summaries (for aggregation updates)
CREATE POLICY "Restaurant owners can manage their sales summaries"
    ON daily_sales_summary FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM restaurants r
            WHERE r.id = daily_sales_summary.restaurant_id
            AND r.owner_id = auth.uid()
        )
    );

-- =====================================================================
-- RLS POLICIES FOR item_performance
-- =====================================================================

-- Restaurant owners can view their item performance metrics
CREATE POLICY "Restaurant owners can view item performance"
    ON item_performance FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM restaurants r
            WHERE r.id = item_performance.restaurant_id
            AND r.owner_id = auth.uid()
        )
    );

-- Restaurant owners can manage their item performance (for aggregation updates)
CREATE POLICY "Restaurant owners can manage item performance"
    ON item_performance FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM restaurants r
            WHERE r.id = item_performance.restaurant_id
            AND r.owner_id = auth.uid()
        )
    );

-- =====================================================================
-- RLS POLICIES FOR item_correlations
-- =====================================================================

-- Restaurant owners can view their item correlations
CREATE POLICY "Restaurant owners can view item correlations"
    ON item_correlations FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM restaurants r
            WHERE r.id = item_correlations.restaurant_id
            AND r.owner_id = auth.uid()
        )
    );

-- Restaurant owners can manage their item correlations (for AI updates)
CREATE POLICY "Restaurant owners can manage item correlations"
    ON item_correlations FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM restaurants r
            WHERE r.id = item_correlations.restaurant_id
            AND r.owner_id = auth.uid()
        )
    );
