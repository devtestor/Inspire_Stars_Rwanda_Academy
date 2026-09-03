-- Inspire Stars editorial content model
create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.stories (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  category text not null default 'Academy news',
  excerpt text not null default '',
  body text not null default '',
  image_url text,
  status text not null default 'draft' check (status in ('draft', 'published')),
  featured boolean not null default false,
  publish_date date not null default current_date,
  author_id uuid not null references auth.users(id) default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists stories_status_date_idx on public.stories(status, publish_date desc);
create index if not exists stories_category_idx on public.stories(category);

create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admin_users where user_id = auth.uid());
$$;

alter table public.admin_users enable row level security;
alter table public.stories enable row level security;

drop policy if exists "Admins can read admin list" on public.admin_users;
create policy "Admins can read admin list" on public.admin_users for select to authenticated using (public.is_admin());

drop policy if exists "Anyone can read published stories" on public.stories;
create policy "Anyone can read published stories" on public.stories for select using (status = 'published' or public.is_admin());
drop policy if exists "Admins can create stories" on public.stories;
create policy "Admins can create stories" on public.stories for insert to authenticated with check (public.is_admin() and author_id = auth.uid());
drop policy if exists "Admins can update stories" on public.stories;
create policy "Admins can update stories" on public.stories for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "Admins can delete stories" on public.stories;
create policy "Admins can delete stories" on public.stories for delete to authenticated using (public.is_admin());

insert into storage.buckets (id, name, public) values ('story-images', 'story-images', true) on conflict (id) do nothing;
drop policy if exists "Public can view story images" on storage.objects;
create policy "Public can view story images" on storage.objects for select using (bucket_id = 'story-images');
drop policy if exists "Admins can upload story images" on storage.objects;
create policy "Admins can upload story images" on storage.objects for insert to authenticated with check (bucket_id = 'story-images' and public.is_admin());
drop policy if exists "Admins can update story images" on storage.objects;
create policy "Admins can update story images" on storage.objects for update to authenticated using (bucket_id = 'story-images' and public.is_admin());
drop policy if exists "Admins can delete story images" on storage.objects;
create policy "Admins can delete story images" on storage.objects for delete to authenticated using (bucket_id = 'story-images' and public.is_admin());

-- After the admin signs in once, run this with their email in the SQL editor:
-- insert into public.admin_users (user_id) select id from auth.users where email = 'admin@example.com' on conflict do nothing;
