-- Thaana Kids Supabase Schema

-- 1. Global Settings
CREATE TABLE IF NOT EXISTS public.settings (
    id TEXT PRIMARY KEY DEFAULT 'global',
    site_name TEXT DEFAULT 'Thaana Kids',
    premium_price TEXT DEFAULT '200 MVR',
    bank_account TEXT DEFAULT '7730000053982',
    bank_name TEXT DEFAULT 'Mohamed Aleef',
    hero_title TEXT DEFAULT 'Learn & Play! 🎨',
    hero_subtitle TEXT DEFAULT 'Start your journey to become a star learner!',
    hero_btn_text TEXT DEFAULT 'Get Started! 🚀',
    hero_emoji TEXT DEFAULT '🎨',
    footer_text TEXT DEFAULT '© 2026 ތާނަ އެކަޑަމީ - މޯލްޑިވްސް',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 2. Kids Profiles
CREATE TABLE IF NOT EXISTS public.kids (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    name TEXT NOT NULL,
    age_group TEXT DEFAULT 'preschool',
    avatar TEXT DEFAULT '👶',
    points INTEGER DEFAULT 0,
    badges INTEGER[] DEFAULT '{}',
    unlocked_avatars TEXT[] DEFAULT '{"👶", "👧", "👦"}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 3. Payments
CREATE TABLE IF NOT EXISTS public.payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    user_email TEXT,
    amount TEXT,
    slip_url TEXT,
    status TEXT DEFAULT 'pending', -- pending, verified, rejected
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- RLS (Row Level Security) - Simplified for starting
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public Read Access" ON public.settings FOR SELECT USING (true);
CREATE POLICY "Admin Write Access" ON public.settings FOR ALL USING (auth.uid() IN (SELECT id FROM auth.users WHERE email = 'YOUR_ADMIN_EMAIL'));

ALTER TABLE public.kids ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own kids" ON public.kids FOR ALL USING (auth.uid() = user_id);

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can see their own payments" ON public.payments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Admin can manage all payments" ON public.payments FOR ALL USING (auth.uid() IN (SELECT id FROM auth.users WHERE email = 'YOUR_ADMIN_EMAIL'));
