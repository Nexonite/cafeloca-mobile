
-- Cafeloca Database Schema v1
-- PostgreSQL / Supabase

create extension if not exists pgcrypto;

-- 1. PROFILES

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. CAFES

create table public.cafes (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  category text,
  address text not null,
  latitude double precision,
  longitude double precision,
  image_url text,
  opening_time time,
  closing_time time,
  price_range text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3. CAFE FACILITIES

create table public.cafe_facilities (
  id uuid primary key default gen_random_uuid(),
  cafe_id uuid not null references public.cafes(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  unique (cafe_id, name)
);

-- 4. CAFE CROWD STATUS

create table public.cafe_crowd_status (
  id uuid primary key default gen_random_uuid(),
  cafe_id uuid not null unique references public.cafes(id) on delete cascade,
  status text not null default 'moderate'
    check (status in ('quiet', 'moderate', 'crowded')),
  updated_at timestamptz not null default now()
);

-- 5. CAFE IMAGES

create table public.cafe_images (
  id uuid primary key default gen_random_uuid(),
  cafe_id uuid not null references public.cafes(id) on delete cascade,
  image_url text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

-- 6. FAVORITES

create table public.favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cafe_id uuid not null references public.cafes(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, cafe_id)
);

-- 7. BOOKINGS

create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cafe_id uuid not null references public.cafes(id),
  booking_date date not null,
  booking_time time not null,
  guest_count integer not null check (guest_count > 0),
  status text not null default 'pending'
    check (status in ('pending', 'confirmed', 'cancelled', 'completed')),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 8. REVIEWS

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cafe_id uuid not null references public.cafes(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, cafe_id)
);

-- INDEXES

create index idx_cafes_active on public.cafes(is_active);
create index idx_cafe_facilities_cafe on public.cafe_facilities(cafe_id);
create index idx_cafe_images_cafe on public.cafe_images(cafe_id);
create index idx_favorites_user on public.favorites(user_id);
create index idx_favorites_cafe on public.favorites(cafe_id);
create index idx_bookings_user on public.bookings(user_id);
create index idx_bookings_cafe on public.bookings(cafe_id);
create index idx_reviews_cafe on public.reviews(cafe_id);

-- ROW LEVEL SECURITY

alter table public.profiles enable row level security;
alter table public.cafes enable row level security;
alter table public.cafe_facilities enable row level security;
alter table public.cafe_crowd_status enable row level security;
alter table public.cafe_images enable row level security;
alter table public.favorites enable row level security;
alter table public.bookings enable row level security;
alter table public.reviews enable row level security;

-- Explicit API grants

grant usage on schema public to anon, authenticated;

grant select on
  public.cafes,
  public.cafe_facilities,
  public.cafe_crowd_status,
  public.cafe_images,
  public.reviews
to anon, authenticated;

grant select, insert, update on public.profiles to authenticated;
grant select, insert, delete on public.favorites to authenticated;
grant select, insert on public.bookings to authenticated;
grant select, insert, update, delete on public.reviews to authenticated;

-- Public cafe read policies

create policy "Read active cafes"
on public.cafes for select
to anon, authenticated
using (is_active = true);

create policy "Read facilities of active cafes"
on public.cafe_facilities for select
to anon, authenticated
using (
  exists (
    select 1 from public.cafes
    where cafes.id = cafe_facilities.cafe_id
      and cafes.is_active = true
  )
);

create policy "Read crowd status of active cafes"
on public.cafe_crowd_status for select
to anon, authenticated
using (
  exists (
    select 1 from public.cafes
    where cafes.id = cafe_crowd_status.cafe_id
      and cafes.is_active = true
  )
);

create policy "Read images of active cafes"
on public.cafe_images for select
to anon, authenticated
using (
  exists (
    select 1 from public.cafes
    where cafes.id = cafe_images.cafe_id
      and cafes.is_active = true
  )
);

-- Profile policies

create policy "Read own profile"
on public.profiles for select
to authenticated
using ((select auth.uid()) = id);

create policy "Insert own profile"
on public.profiles for insert
to authenticated
with check ((select auth.uid()) = id);

create policy "Update own profile"
on public.profiles for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

-- Favorite policies

create policy "Read own favorites"
on public.favorites for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Insert own favorites"
on public.favorites for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1 from public.cafes
    where cafes.id = favorites.cafe_id
      and cafes.is_active = true
  )
);

create policy "Delete own favorites"
on public.favorites for delete
to authenticated
using ((select auth.uid()) = user_id);

-- Booking policies

create policy "Read own bookings"
on public.bookings for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "Create own bookings"
on public.bookings for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and status = 'pending'
  and exists (
    select 1 from public.cafes
    where cafes.id = bookings.cafe_id
      and cafes.is_active = true
  )
);

-- Review policies

create policy "Read reviews for active cafes"
on public.reviews for select
to anon, authenticated
using (
  exists (
    select 1 from public.cafes
    where cafes.id = reviews.cafe_id
      and cafes.is_active = true
  )
);

create policy "Create own review"
on public.reviews for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1 from public.cafes
    where cafes.id = reviews.cafe_id
      and cafes.is_active = true
  )
);

create policy "Update own review"
on public.reviews for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "Delete own review"
on public.reviews for delete
to authenticated
using ((select auth.uid()) = user_id);
