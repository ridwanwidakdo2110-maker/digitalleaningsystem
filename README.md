# Smanfuma Digital Learning

## Status deployment
- Frontend statis dapat di-host di Netlify.
- Backend pada `api.php` dan `config.php` membutuhkan PHP/MySQL, jadi harus dijalankan pada layanan backend yang mendukung PHP dan koneksi MySQL (mis. VPS atau layanan PHP hosting).
- Netlify tidak menjalankan file PHP langsung sebagai static hosting.

## Database
`database.sql` berisi schema MySQL 8 untuk LMS. Sebelum menggunakannya:
1. Buat database MySQL `smanfuma_lms`.
2. Import schema dengan `mysql -u USER -p < database.sql`.
3. Import data guru dan siswa melalui proses backend tepercaya. Jangan publish data pribadi siswa/guru di repo publik.
4. Cadangkan database sebelum menjalankan migrasi pada instalasi yang sudah berisi data.

## Konfigurasi backend
Konfigurasikan kredensial database melalui environment variables pada host backend, bukan di repo publik:
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASS`

Contoh perubahan `config.php` yang dapat digunakan:
```php
$DB_HOST = getenv('DB_HOST') ?: '127.0.0.1';
$DB_PORT = getenv('DB_PORT') ?: '3306';
$DB_NAME = getenv('DB_NAME') ?: 'smanfuma_lms';
$DB_USER = getenv('DB_USER') ?: 'root';
$DB_PASS = getenv('DB_PASS') ?: '';
```

## Netlify
Gunakan Netlify untuk frontend, dan konfigurasikan URL API production pada frontend agar menunjuk ke host backend PHP. Jangan gunakan `localhost` pada deployment. Untuk keamanan, API juga harus menerapkan autentikasi dan validasi akses; NIP/NIS dan nama yang dikirim dari browser saja bukan mekanisme autentikasi yang aman.
