# Smanfuma Digital Learning

## Catatan penting tentang deployment

Proyek ini memiliki backend PHP + MySQL pada file `api.php` dan `config.php`.
Netlify hanya cocok untuk frontend statis. Karena itu, jangan deploy `api.php` langsung ke Netlify sebagai file PHP.

Gunakan arsitektur berikut:

1. Deploy frontend ke Netlify
2. Deploy backend PHP ke Render, Railway, atau VPS Linux
3. Pastikan semua request API diarahkan ke URL backend yang valid
4. Simpan URL backend di file `config.js` atau `window.API_BASE_URL`

## Fix database

File `database.sql` sudah diperbaiki agar:
- tidak ada duplikasi `ON DUPLICATE KEY UPDATE`
- kolom `teacher_id` tersedia untuk `subjects`, `evaluations`, dan `announcements`
- struktur MySQL 8 lebih konsisten

## Langkah migrasi cepat

1. Buat database `smanfuma_lms`
2. Jalankan `database.sql`
3. Import data guru/siswa dari `school_data.json` jika diperlukan
4. Uji koneksi PHP lewat endpoint API

## Netlify deployment

- Hubungkan repo ke Netlify
- Build command: `echo 'Static site: frontend assets are served directly.'`
- Publish directory: `.`
- Pastikan file HTML/JS Anda tidak call API ke `localhost` di production

## Backend hosting rekomendasi

- Render: PHP Web Service + MySQL external
- Railway: Railway App + MySQL
- VPS: Ubuntu + Nginx + PHP-FPM

## Catatan

Jika Anda ingin saya lanjutkan, saya bisa bantu:
- menyiapkan file frontend yang siap terhubung dengan backend
- mengubah endpoint API agar kompatibel dengan Netlify-hosted frontend
- menyiapkan konfigurasi deploy ke Render/Railway
