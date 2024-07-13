# OK OCE NET

Repository ini berisi modul backend dan frontend untuk aplikasi OK OCE NET.

## Setup Backend

### Prasyarat

- Docker
- Node.js 16.x
- npm

### Instalasi

1. Clone repository ini:
   ```bash
   git clone --recurse-submodules https://github.com/Ahmdfdhilah/okocnet
   cd okocnet
   ```

2. Masuk ke direktori backend:
   ```bash
   cd backend
   ```

3. Setel variabel lingkungan:
   - Buat file `.env` berdasarkan contoh dari `.env.example` dan konfigurasikan sesuai kebutuhan.

4. Bangun dan jalankan backend menggunakan Docker:
   ```bash
   docker-compose up --build
   ```

5. API backend dapat diakses melalui [https://sole-debi-crytonexa-deb22e0b.koyeb.app/](https://sole-debi-crytonexa-deb22e0b.koyeb.app/).

6. Dokumentasi Swagger API dapat diakses di [https://sole-debi-crytonexa-deb22e0b.koyeb.app/api](https://sole-debi-crytonexa-deb22e0b.koyeb.app/api).

### Struktur Backend

- `src/`: Berisi kode sumber backend.
- `public/upload/`: Direktori untuk mengunggah file.

## Setup Frontend

### Prasyarat

- Node.js 16.x
- npm

### Instalasi

1. Masuk ke direktori frontend:
   ```bash
   cd frontend
   ```

2. Instal dependensi:
   ```bash
   npm install
   ```

3. Bangun frontend:
   ```bash
   npm run build
   ```

4. File frontend yang sudah dibangun terletak di `frontend/build/`.

5. Aplikasi frontend telah didistribusikan di Vercel dan dapat diakses di [https://okocenet.vercel.app](https://okocenet.vercel.app).

### Login CMS

- Akses login CMS di [https://okocenet.vercel.app/okoclogin](https://okocenet.vercel.app/okoclogin).

## Konfigurasi Docker Compose

File `docker-compose.yml` di direktori utama dikonfigurasi untuk menjalankan layanan backend dan database menggunakan Docker. Ini termasuk layanan untuk:
- API Backend
- Basis data MariaDB (`db` dan `db_backup`)
- Antarmuka phpMyAdmin untuk manajemen database

### Layanan

- `app`: Layanan API Backend yang dapat diakses di `http://localhost:3000`.
- `db`: Basis data MariaDB untuk data aplikasi OK OCE.
- `db_backup`: Basis data MariaDB untuk tujuan pencadangan.
- `phpmyadmin`: Antarmuka phpMyAdmin untuk manajemen database, dapat diakses di [http://localhost:8080](http://localhost:8080).

### Jaringan

- `backend-network`: Jaringan Docker untuk komunikasi antara layanan.

### Volume

- `db_data`: Volume untuk penyimpanan data persisten dari layanan `db`.
- `db_backup_data`: Volume untuk penyimpanan data persisten dari layanan `db_backup`.