
-- CAfELOCA v0.4
-- Development seed data
-- All cafes below are fictional examples.

insert into public.cafes (
  id,
  name,
  description,
  category,
  address,
  image_url,
  opening_time,
  closing_time,
  price_range,
  is_active
)
values
(
  '10000000-0000-4000-8000-000000000001',
  'Kopi Senja',
  'A cozy cafe for working, reading, and enjoying a quiet afternoon.',
  'Coffee Shop',
  'Sample Location, Jakarta',
  null,
  '08:00',
  '22:00',
  '$$',
  true
),
(
  '10000000-0000-4000-8000-000000000002',
  'Ruang Temu',
  'A comfortable gathering space with a warm atmosphere.',
  'Cafe & Eatery',
  'Sample Location, Bandung',
  null,
  '09:00',
  '23:00',
  '$$',
  true
),
(
  '10000000-0000-4000-8000-000000000003',
  'Bumi Brew',
  'A modern coffee destination with a relaxed environment.',
  'Specialty Coffee',
  'Sample Location, Jakarta',
  null,
  '07:00',
  '21:00',
  '$$$',
  true
),
(
  '10000000-0000-4000-8000-000000000004',
  'Teras Pagi',
  'A bright and welcoming place for breakfast and coffee.',
  'Cafe & Bakery',
  'Sample Location, Bandung',
  null,
  '07:00',
  '20:00',
  '$$',
  true
),
(
  '10000000-0000-4000-8000-000000000005',
  'Sudut Cerita',
  'A casual neighborhood cafe for conversations and relaxation.',
  'Coffee Shop',
  'Sample Location, Jakarta',
  null,
  '10:00',
  '22:00',
  '$',
  true
)
on conflict (id) do nothing;

-- Facilities

insert into public.cafe_facilities (
  cafe_id,
  name
)
values
('10000000-0000-4000-8000-000000000001', 'Wi-Fi'),
('10000000-0000-4000-8000-000000000001', 'Power Outlet'),
('10000000-0000-4000-8000-000000000002', 'Wi-Fi'),
('10000000-0000-4000-8000-000000000002', 'Parking'),
('10000000-0000-4000-8000-000000000003', 'Wi-Fi'),
('10000000-0000-4000-8000-000000000003', 'Power Outlet'),
('10000000-0000-4000-8000-000000000004', 'Outdoor Seating'),
('10000000-0000-4000-8000-000000000005', 'Wi-Fi')
on conflict (cafe_id, name) do nothing;

-- Initial crowd status

insert into public.cafe_crowd_status (
  cafe_id,
  status
)
values
('10000000-0000-4000-8000-000000000001', 'quiet'),
('10000000-0000-4000-8000-000000000002', 'moderate'),
('10000000-0000-4000-8000-000000000003', 'crowded'),
('10000000-0000-4000-8000-000000000004', 'quiet'),
('10000000-0000-4000-8000-000000000005', 'moderate')
on conflict (cafe_id) do nothing;
