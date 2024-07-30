# OK OCE NET

Proyek ini adalah aplikasi full-stack yang dibangun dengan NestJS untuk backend dan React untuk frontend, menggunakan Docker untuk kontainerisasi.

## Daftar Isi

- [OK OCE NET](#ok-oce-net)
  - [Daftar Isi](#daftar-isi)
  - [Memulai](#memulai)
    - [Prasyarat](#prasyarat)
    - [Mengkloning Repository](#mengkloning-repository)
  - [Arsitektur](#arsitektur)
    - [Backend](#backend)
    - [Frontend](#frontend)
  - [Pengaturan Docker](#pengaturan-docker)
    - [Dockerfile (Backend)](#dockerfile-backend)
    - [Dockerfile (Frontend)](#dockerfile-frontend)
    - [docker-compose.yml](#docker-composeyml)
  - [Dokumentasi API](#dokumentasi-api)
    - [Fitur Middleware dan Keamanan Utama](#fitur-middleware-dan-keamanan-utama)
  - [Submodul Git](#submodul-git)
  - [Backup Database](#backup-database)
  - [Penggunaan Redis](#penggunaan-redis)
    - [Konfigurasi](#konfigurasi)
  - [Kesimpulan](#kesimpulan)
  - [Requirements untuk Produksi](#requirements-untuk-produksi)

## Memulai

### Prasyarat

- Docker
- Docker Compose

### Mengkloning Repository

```bash
git clone --recurse-submodules https://github.com/Ahmdfdhilah/okocnet.git
cd okocnet
```

## Arsitektur

### Backend

Backend dibangun dengan NestJS dan mengikuti arsitektur modular, menggunakan TypeORM untuk interaksi database. Ini memiliki beberapa modul, termasuk manajemen pengguna, berita, magang, donasi, dan lainnya.

### Frontend

Frontend dibangun dengan React dan menangani interaksi pengguna, melakukan panggilan API ke layanan backend.

## Pengaturan Docker

### Dockerfile (Backend)

```dockerfile
FROM node:18

WORKDIR /usr/src/app

COPY . .

RUN npm install

RUN npm run build

EXPOSE 3000

CMD [ "npm", "run", "start:dev" ]
```

### Dockerfile (Frontend)

```dockerfile
FROM node:14-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

ENV PORT=3001

EXPOSE 3001

CMD ["npm", "start"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    volumes:
      - ./frontend/src:/usr/src/app/src
    ports:
      - '3001:3001'
    environment:
      - NODE_ENV=development
      - WATCHPACK_POLLING=true
      - PORT=3001

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - '3000:3000'  
    env_file:
      - ./backend/.env
    depends_on:
      - db
      - db_backup

  db:
    image: mariadb:10.6
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_USER=testuser
      - MYSQL_PASSWORD=password
      - MYSQL_TCP_PORT=3307
      - MYSQL_DATABASE=okoce
    volumes:
      - db_data:/var/lib/mysql

  db_backup:
    image: mariadb:10.6
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_USER=testuser
      - MYSQL_PASSWORD=password
      - MYSQL_TCP_PORT=3308
      - MYSQL_DATABASE=okoce_backup
    volumes:
      - db_backup_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin
    restart: always
    ports:
      - '8080:80' 
    environment:
      - PMA_ARBITRARY=1 
      - PMA_PORT=3307
      - PMA_HOST=db
      - PMA_PASSWORD=password
      - PMA_USER=testuser

networks:
  backend-network:
    driver: bridge

volumes:
  db_data:
  db_backup_data:
```

## Dokumentasi API

API didokumentasikan menggunakan Swagger. Anda dapat mengakses dokumentasi dengan menavigasi ke `https://okocenet-72f35a89c2ef.herokuapp.com/api` setelah memulai layanan backend.

### Fitur Middleware dan Keamanan Utama

- **Helmet**: Menambahkan header keamanan ke respons HTTP.
- **Rate Limiting**: Membatasi jumlah permintaan per IP untuk mencegah penyalahgunaan.
- **Content Security Policy (CSP)**: Membatasi pemuatan sumber daya untuk meningkatkan keamanan.

## Submodul Git

Proyek ini menggunakan submodul Git untuk backend dan frontend:

```git
[submodule "backend"]
    path = backend
    url = https://github.com/Ahmdfdhilah/okocnetbackend
[submodule "frontend"]
    path = frontend
    url = https://github.com/Ahmdfdhilah/okocnetfrontend
```

## Backup Database

Aplikasi ini dikonfigurasi dengan database cadangan untuk memastikan redundansi data dan keandalan. Ini dikelola menggunakan dua kontainer MariaDB terpisah:

- **db**: Layanan database MariaDB utama.
- **db_backup**: Layanan database MariaDB cadangan.

Kedua database didefinisikan dalam file `docker-compose.yml`, dan masing-masing memiliki volume sendiri untuk penyimpanan persisten. Database cadangan berfungsi sebagai solusi failover untuk mencegah kehilangan data jika terjadi masalah dengan database utama.

Dengan mengatur dua layanan database ini, kami memastikan bahwa selalu ada cadangan yang tersedia, meminimalkan risiko kehilangan data, dan meningkatkan keandalan aplikasi.

## Penggunaan Redis

Aplikasi ini memanfaatkan Redis untuk caching dan meningkatkan kinerja. Secara khusus, menggunakan Upstash Redis, solusi Redis tanpa server yang menawarkan latensi rendah dan ketersediaan tinggi. Berikut cara integrasi Redis ke backend:

1. **Instalasi**: Pastikan paket `@upstash/redis` terinstal dalam aplikasi NestJS Anda.

```bash
npm install @upstash/redis
```

2. **Konfigurasi**: Konfigurasi pengaturan koneksi Redis menggunakan variabel lingkungan Upstash.

3. **Penggunaan**: Implementasikan strategi caching dalam layanan Anda untuk menyimpan data yang sering diakses dalam Redis, mengurangi beban pada database dan mempercepat waktu respons.

### Konfigurasi

Buat klien Redis menggunakan Upstash Redis:

```typescript
import { Redis } from '@upstash/redis';

const redis = new Redis({
  url: process.env.UPSTASH_REDIS_REST_URL,
  token: process.env.UPSTASH_REDIS_REST_TOKEN,
});

export default redis;
```

Dengan mengintegrasikan Upstash Redis, Anda dapat meningkatkan kinerja dan skalabilitas aplikasi melalui mekanisme caching yang efisien.

## Kesimpulan

Ikuti instruksi ini untuk mengatur dan menjalankan aplikasi OK OCE NET. Untuk masalah apa pun, silakan merujuk ke dokumentasi atau halaman masalah GitHub untuk bantuan atau hubungi saya di WhatsApp 089647107815.

## Requirements untuk Produksi

- Redis menggunakan serverless Redis dari Upstash
- Database dan backup database MySQL menggunakan CleverCloud
- Backend menggunakan Heroku
- Frontend menggunakan Vercel