-- Jalankan di Supabase Dashboard > SQL Editor

create extension if not exists pgcrypto;

create table if not exists public.pembatalan (
  id uuid primary key default gen_random_uuid(),
  tanggal timestamptz not null default now(),
  toko text,
  no_pesanan text not null,
  kode_barang text not null,
  qty int not null default 1,
  alasan text,
  created_at timestamptz not null default now()
);

create table if not exists public.kendala_mingguan (
  id uuid primary key default gen_random_uuid(),
  tanggal_order date,
  tanggal_komplain date not null default current_date,
  toko text,
  nama_akun text,
  no_pesanan text not null,
  resi text,
  kendala text,
  solusi text,
  created_at timestamptz not null default now()
);

create table if not exists public.resi_naik (
  id uuid primary key default gen_random_uuid(),
  tanggal date not null default current_date,
  toko text,
  no_pesanan text not null,
  resi text,
  barang text,
  qty int not null default 1,
  alasan text,
  keputusan text,
  foto_resi text,
  created_at timestamptz not null default now()
);

-- Untuk database yang sudah dibuat sebelumnya: tambah kolom toko
alter table public.pembatalan add column if not exists toko text;
alter table public.resi_naik add column if not exists toko text;
alter table public.resi_naik add column if not exists keputusan text;

-- Row Level Security: hanya user yang login yang bisa akses
alter table public.pembatalan enable row level security;
alter table public.kendala_mingguan enable row level security;
alter table public.resi_naik enable row level security;

do $$
declare t text;
begin
  foreach t in array array['pembatalan','kendala_mingguan','resi_naik'] loop
    execute format('drop policy if exists "auth_all" on public.%I', t);
    execute format(
      'create policy "auth_all" on public.%I for all to authenticated using (true) with check (true)', t);
  end loop;
end $$;

-- Storage bucket untuk foto resi
insert into storage.buckets (id, name, public)
values ('foto-resi', 'foto-resi', true)
on conflict (id) do nothing;

drop policy if exists "foto_resi_upload" on storage.objects;
create policy "foto_resi_upload" on storage.objects
  for insert to authenticated with check (bucket_id = 'foto-resi');

drop policy if exists "foto_resi_delete" on storage.objects;
create policy "foto_resi_delete" on storage.objects
  for delete to authenticated using (bucket_id = 'foto-resi');

-- Data awal dari REKAP_CANCEL.xlsx
insert into public.pembatalan (tanggal, no_pesanan, kode_barang, qty, alasan) values
  ('2026-11-09 12:54:00+07', '261109T8UEFPT1', 'PW-Y 02 (Lebar17cm) · 1 METER', 2, 'Ingin Co Ulang');

insert into public.kendala_mingguan (tanggal_order, tanggal_komplain, toko, nama_akun, no_pesanan, resi, kendala, solusi) values
  ('2026-10-23','2026-11-02','Tianzhy','dellafendhysa','261023DF0YY9XS','201840341035','RUSAK','Kompensasi'),
  ('2026-10-31','2026-11-02','Tianzhy','reni_ruby2','2610313RBR0FPE','JT92357387806','RUSAK','Retur'),
  ('2026-10-25','2026-11-02','SerbaBpp','jumhamri','261025HMJ0TYXE','201842338845','rusak dan tidak sesuai pesanan yang di pesan abu2 yang datang warna cream','Kompensasi'),
  ('2026-10-27','2026-10-31','Tianzhy','nanthaba','261027P75YH5QN','201842338845','RUSAK','Kompensasi'),
  ('2026-10-28','2026-11-04','Serbajkt','sufatulfitria','261028SW1HTGD8','201850205126','RUSAK','Kompensasi'),
  ('2026-10-25','2026-11-03','Serbajkt','euis_nh','261025GAEYP185','JT19800580442','RUSAK','Kompensasi'),
  ('2026-10-31','2026-11-04','Tianzhy','aim_army','2610313QSBJU0C','JT34977402499','RUSAK','Kompensasi');

insert into public.resi_naik (tanggal, no_pesanan, resi, barang, qty, alasan) values
  ('2026-11-09','261109RUB53P3E','SPXID06627882616B','MPM KS - 806R',1,'KOSONG'),
  ('2026-11-08','261108RM0A5SJ2','201868106283','BINTIK PUTIH',85,'SISA 65'),
  ('2026-11-09','261109T62494BR','JT94936658219','PW Y 04',24,'SISA 14');
