-- Add RLS policies to tables that have RLS enabled but no policies
-- Using staff_members table for membership checks

-- 1. analytics_events - restaurant members can manage their own analytics
CREATE POLICY "Restaurant members can view their analytics"
ON public.analytics_events FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.staff_members sm
        WHERE sm.restaurant_id = analytics_events.restaurant_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant members can insert analytics"
ON public.analytics_events FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.staff_members sm
        WHERE sm.restaurant_id = analytics_events.restaurant_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

-- 2. order_items - accessible through orders relationship
CREATE POLICY "Restaurant members can view order items"
ON public.order_items FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.orders o
        JOIN public.staff_members sm ON sm.restaurant_id = o.restaurant_id
        WHERE o.id = order_items.order_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant members can manage order items"
ON public.order_items FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.orders o
        JOIN public.staff_members sm ON sm.restaurant_id = o.restaurant_id
        WHERE o.id = order_items.order_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant members can update order items"
ON public.order_items FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM public.orders o
        JOIN public.staff_members sm ON sm.restaurant_id = o.restaurant_id
        WHERE o.id = order_items.order_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant members can delete order items"
ON public.order_items FOR DELETE
USING (
    EXISTS (
        SELECT 1 FROM public.orders o
        JOIN public.staff_members sm ON sm.restaurant_id = o.restaurant_id
        WHERE o.id = order_items.order_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

-- 3. staff_members - members can view staff in their restaurant, owners can manage
CREATE POLICY "Restaurant members can view staff"
ON public.staff_members FOR SELECT
USING (
    restaurant_id IN (
        SELECT sm.restaurant_id FROM public.staff_members sm
        WHERE sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant owners can manage staff"
ON public.staff_members FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.restaurants r
        WHERE r.id = staff_members.restaurant_id
        AND r.owner_id = auth.uid()
    )
);

CREATE POLICY "Restaurant owners can update staff"
ON public.staff_members FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM public.restaurants r
        WHERE r.id = staff_members.restaurant_id
        AND r.owner_id = auth.uid()
    )
);

CREATE POLICY "Restaurant owners can delete staff"
ON public.staff_members FOR DELETE
USING (
    EXISTS (
        SELECT 1 FROM public.restaurants r
        WHERE r.id = staff_members.restaurant_id
        AND r.owner_id = auth.uid()
    )
);

-- 4. subscriptions - restaurant members can view, owners can manage
CREATE POLICY "Restaurant members can view subscriptions"
ON public.subscriptions FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.staff_members sm
        WHERE sm.restaurant_id = subscriptions.restaurant_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant owners can manage subscriptions"
ON public.subscriptions FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.restaurants r
        WHERE r.id = subscriptions.restaurant_id
        AND r.owner_id = auth.uid()
    )
);

CREATE POLICY "Restaurant owners can update subscriptions"
ON public.subscriptions FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM public.restaurants r
        WHERE r.id = subscriptions.restaurant_id
        AND r.owner_id = auth.uid()
    )
);

-- 5. video_generation_jobs - restaurant members can access their jobs
CREATE POLICY "Restaurant members can view video jobs"
ON public.video_generation_jobs FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.staff_members sm
        WHERE sm.restaurant_id = video_generation_jobs.restaurant_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant members can create video jobs"
ON public.video_generation_jobs FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.staff_members sm
        WHERE sm.restaurant_id = video_generation_jobs.restaurant_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);

CREATE POLICY "Restaurant members can update video jobs"
ON public.video_generation_jobs FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM public.staff_members sm
        WHERE sm.restaurant_id = video_generation_jobs.restaurant_id
        AND sm.user_id = auth.uid()
        AND sm.is_active = true
    )
);
