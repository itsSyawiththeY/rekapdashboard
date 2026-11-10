# Rekap Cancel — Supabase + Netlify

Web app untuk rekap pembatalan, kendala mingguan, dan resi naik (dari `REKAP_CANCEL.xlsx`).

## 1. Setup Supabase
1. Buat project di https://supabase.com
2. Buka **SQL Editor**, paste isi `supabase/schema.sql`, lalu **Run**
   (bikin 3 tabel, RLS, bucket `foto-resi`, dan mengisi data dari Excel).
3. **Authentication > Users > Add user**: buat akun email + password untuk login.
4. **Authentication > Providers > Email**: matikan *Allow new users to sign up*
   supaya orang lain tidak bisa daftar sendiri.
5. **Project Settings > API**: salin **Project URL** dan **anon public key**.

## 2. Deploy ke Netlify
1. Push folder ini ke GitHub.
2. Netlify > **Add new site > Import from Git**. Setting build sudah terbaca dari `netlify.toml`.
3. **Site configuration > Environment variables**, tambahkan:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Deploy. Selesai.

## Jalan lokal
```
cp .env.example .env     # isi nilainya
node build.js
npx serve public
```

## Catatan keamanan
Anon key memang aman ada di frontend karena akses data dijaga RLS
(hanya user yang sudah login). Jangan pernah pakai `service_role` key di sini.
