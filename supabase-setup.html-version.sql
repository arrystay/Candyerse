create extension if not exists "pgcrypto";

insert into storage.buckets (id, name, public)
values ('covers', 'covers', true)
on conflict (id) do update set public = true;

create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text not null default 'Unknown Author',
  category text not null default 'Uncategorized',
  isbn text not null default '',
  shelf text not null default '',
  status text not null default 'Available',
  cover_url text not null default '',
  rating text,
  chapters jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.books enable row level security;

drop policy if exists "Public can read books" on public.books;
create policy "Public can read books"
on public.books for select
using (true);

drop policy if exists "Anyone can add books from admin page" on public.books;
create policy "Anyone can add books from admin page"
on public.books for insert
with check (true);

drop policy if exists "Anyone can update books from admin page" on public.books;
create policy "Anyone can update books from admin page"
on public.books for update
using (true)
with check (true);

drop policy if exists "Anyone can delete books from admin page" on public.books;
create policy "Anyone can delete books from admin page"
on public.books for delete
using (true);

drop policy if exists "Public can read covers" on storage.objects;
create policy "Public can read covers"
on storage.objects for select
using (bucket_id = 'covers');

drop policy if exists "Anyone can upload covers from admin page" on storage.objects;
create policy "Anyone can upload covers from admin page"
on storage.objects for insert
with check (bucket_id = 'covers');

drop policy if exists "Anyone can update covers from admin page" on storage.objects;
create policy "Anyone can update covers from admin page"
on storage.objects for update
using (bucket_id = 'covers')
with check (bucket_id = 'covers');
