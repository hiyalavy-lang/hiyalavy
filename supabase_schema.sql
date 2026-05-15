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
    stats JSONB DEFAULT '{}'::jsonb,
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

-- 4. App Navigation
CREATE TABLE IF NOT EXISTS public.app_nav (
    id TEXT PRIMARY KEY,
    icon TEXT,
    label TEXT,
    premium BOOLEAN DEFAULT false,
    order_index INTEGER DEFAULT 0
);

-- 5. App Curriculum Content (Letters/Words)
CREATE TABLE IF NOT EXISTS public.app_content (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL,
    letter TEXT NOT NULL,
    name TEXT,
    audio TEXT,
    word TEXT,
    word_audio TEXT,
    english TEXT,
    dhivehi TEXT,
    count_word_dhivehi TEXT,
    count_word_english TEXT,
    audio_dhivehi TEXT,
    audio_english TEXT,
    quiz_question TEXT,
    quiz_options TEXT,
    ghost_image TEXT,
    order_index INTEGER DEFAULT 0
);

-- 6. App Vowels (Fili)
CREATE TABLE IF NOT EXISTS public.app_fili (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    mark TEXT NOT NULL,
    name TEXT NOT NULL,
    audio TEXT,
    order_index INTEGER DEFAULT 0
);

-- Storage buckets (must be run in Supabase SQL Editor manually or via API)
-- insert into storage.buckets (id, name, public) values ('slips', 'slips', true);
-- insert into storage.buckets (id, name, public) values ('audio', 'audio', true);

-- Storage RLS Policies
DROP POLICY IF EXISTS "Public access to slips" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload slips" ON storage.objects;
DROP POLICY IF EXISTS "Public access to audio" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload audio" ON storage.objects;

CREATE POLICY "Public access to slips" ON storage.objects FOR SELECT USING (bucket_id = 'slips');
CREATE POLICY "Authenticated users can upload slips" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'slips' AND auth.role() = 'authenticated');

CREATE POLICY "Public access to audio" ON storage.objects FOR SELECT USING (bucket_id = 'audio');
CREATE POLICY "Authenticated users can upload audio" ON storage.objects FOR ALL USING (bucket_id = 'audio' AND (auth.jwt() ->> 'email') = 'alippalhey@gmail.com');

-- RLS (Row Level Security) - Simplified for starting
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Read Access Settings" ON public.settings;
DROP POLICY IF EXISTS "Admin Write Access Settings" ON public.settings;
CREATE POLICY "Public Read Access Settings" ON public.settings FOR SELECT USING (true);
CREATE POLICY "Admin Write Access Settings" ON public.settings FOR ALL USING ((auth.jwt() ->> 'email') = 'alippalhey@gmail.com');

ALTER TABLE public.kids ADD COLUMN IF NOT EXISTS pin TEXT DEFAULT '1234';

ALTER TABLE public.kids ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can manage their own kids" ON public.kids;
CREATE POLICY "Users can manage their own kids" ON public.kids FOR ALL USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Public Read Access Kids" ON public.kids;
CREATE POLICY "Public Read Access Kids" ON public.kids FOR SELECT USING (true);

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can see their own payments" ON public.payments;
DROP POLICY IF EXISTS "Users can insert their own payments" ON public.payments;
DROP POLICY IF EXISTS "Admin can manage all payments" ON public.payments;
CREATE POLICY "Users can see their own payments" ON public.payments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own payments" ON public.payments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Admin can manage all payments" ON public.payments FOR ALL USING ((auth.jwt() ->> 'email') = 'alippalhey@gmail.com');

ALTER TABLE public.app_nav ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Read Access Nav" ON public.app_nav;
DROP POLICY IF EXISTS "Admin Write Access Nav" ON public.app_nav;
CREATE POLICY "Public Read Access Nav" ON public.app_nav FOR SELECT USING (true);
CREATE POLICY "Admin Write Access Nav" ON public.app_nav FOR ALL USING ((auth.jwt() ->> 'email') = 'alippalhey@gmail.com');

ALTER TABLE public.app_content ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Read Access Content" ON public.app_content;
DROP POLICY IF EXISTS "Admin Write Access Content" ON public.app_content;
CREATE POLICY "Public Read Access Content" ON public.app_content FOR SELECT USING (true);
CREATE POLICY "Admin Write Access Content" ON public.app_content FOR ALL USING ((auth.jwt() ->> 'email') = 'alippalhey@gmail.com');

ALTER TABLE public.app_fili ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public Read Access Fili" ON public.app_fili;
DROP POLICY IF EXISTS "Admin Write Access Fili" ON public.app_fili;
CREATE POLICY "Public Read Access Fili" ON public.app_fili FOR SELECT USING (true);
CREATE POLICY "Admin Write Access Fili" ON public.app_fili FOR ALL USING ((auth.jwt() ->> 'email') = 'alippalhey@gmail.com');

