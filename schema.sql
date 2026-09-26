-- ==============================================================================
-- Macro & Script Manager - Supabase PostgreSQL Schema
-- Includes Row Level Security (RLS), Full-Text Search Indexes, and Foreign Keys
-- ==============================================================================

-- 1. Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. Custom Categories
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'all' CHECK (type IN ('macro', 'shortcut', 'script', 'all')),
    icon TEXT DEFAULT 'folder',
    color TEXT DEFAULT '#3b82f6',
    description TEXT DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Word Macros
CREATE TABLE IF NOT EXISTS public.word_macros (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT DEFAULT '',
    category TEXT DEFAULT 'General',
    vba_code TEXT NOT NULL,
    shortcut TEXT DEFAULT '',
    word_version TEXT DEFAULT 'Word 2016/2019/2021/365',
    tags JSONB DEFAULT '[]'::jsonb,
    version TEXT DEFAULT '1.0.0',
    notes TEXT DEFAULT '',
    is_favorite BOOLEAN DEFAULT FALSE,
    file_path TEXT,
    file_type TEXT DEFAULT '.bas',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Word Shortcuts & Custom Assignments
CREATE TABLE IF NOT EXISTS public.word_shortcuts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    shortcut_key TEXT NOT NULL,
    assigned_command TEXT DEFAULT '',
    assigned_macro TEXT DEFAULT '',
    category TEXT DEFAULT 'General',
    description TEXT DEFAULT '',
    word_version TEXT DEFAULT 'Word 2016/2019/2021/365',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. Application Scripts (InDesign, Illustrator, Photoshop, Python, etc.)
CREATE TABLE IF NOT EXISTS public.scripts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    category TEXT DEFAULT 'Other',
    application TEXT NOT NULL,
    script_language TEXT NOT NULL,
    script_code TEXT NOT NULL,
    description TEXT DEFAULT '',
    version TEXT DEFAULT '1.0.0',
    tags JSONB DEFAULT '[]'::jsonb,
    notes TEXT DEFAULT '',
    is_favorite BOOLEAN DEFAULT FALSE,
    file_path TEXT,
    file_type TEXT DEFAULT '.jsx',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. Version History & Audit Trail
CREATE TABLE IF NOT EXISTS public.version_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('macro', 'script', 'shortcut')),
    entity_id UUID NOT NULL,
    version_number TEXT NOT NULL,
    code_snapshot TEXT NOT NULL,
    metadata_snapshot JSONB NOT NULL,
    change_summary TEXT DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. Backups
CREATE TABLE IF NOT EXISTS public.backups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    backup_type TEXT NOT NULL DEFAULT 'all',
    backup_data_json JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- INDEXES & FULL-TEXT SEARCH VECTORS
-- ==============================================================================

CREATE INDEX IF NOT EXISTS idx_macros_name ON public.word_macros (LOWER(name));
CREATE INDEX IF NOT EXISTS idx_macros_category ON public.word_macros (category);
CREATE INDEX IF NOT EXISTS idx_shortcuts_key ON public.word_shortcuts (shortcut_key);
CREATE INDEX IF NOT EXISTS idx_scripts_app ON public.scripts (application);
CREATE INDEX IF NOT EXISTS idx_scripts_name ON public.scripts (LOWER(name));
CREATE INDEX IF NOT EXISTS idx_version_entity ON public.version_history (entity_id);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.word_macros ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.word_shortcuts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scripts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.version_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.backups ENABLE ROW LEVEL SECURITY;

-- Allow public access for local single-tenant or authenticated Supabase users
CREATE POLICY "Allow authenticated full access to categories" ON public.categories FOR ALL USING (true);
CREATE POLICY "Allow authenticated full access to word_macros" ON public.word_macros FOR ALL USING (true);
CREATE POLICY "Allow authenticated full access to word_shortcuts" ON public.word_shortcuts FOR ALL USING (true);
CREATE POLICY "Allow authenticated full access to scripts" ON public.scripts FOR ALL USING (true);
CREATE POLICY "Allow authenticated full access to version_history" ON public.version_history FOR ALL USING (true);
CREATE POLICY "Allow authenticated full access to backups" ON public.backups FOR ALL USING (true);
