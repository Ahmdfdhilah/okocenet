# OK OCE NET

This project is a full-stack application built with NestJS for the backend and React for the frontend, utilizing Docker for containerization.

## Table of Contents

- [OK OCE NET](#ok-oce-net)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Cloning the Repository](#cloning-the-repository)
  - [Architecture](#architecture)
    - [Backend](#backend)
    - [Frontend](#frontend)
  - [Docker Setup](#docker-setup)
    - [Dockerfile (Backend)](#dockerfile-backend)
    - [Dockerfile (Frontend)](#dockerfile-frontend)
    - [docker-compose.yml](#docker-composeyml)
  - [API Documentation](#api-documentation)
    - [Key Middleware and Security Features](#key-middleware-and-security-features)
  - [Git Submodules](#git-submodules)
  - [Database Backup](#database-backup)
  - [Redis Usage](#redis-usage)
    - [Configuration](#configuration)
    - [Usage](#usage)
  - [Conclusion](#conclusion)

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Cloning the Repository

```bash
git clone --recurse-submodules https://github.com/Ahmdfdhilah/okocnet.git
cd okocnet
```

## Architecture

### Backend

The backend is built with NestJS and follows a modular architecture, using TypeORM for database interactions. It features several modules, including user management, news, internships, donations, and more.

### Frontend

The frontend is built with React and handles user interactions, making API calls to the backend services.

## Docker Setup

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

## API Documentation

The API is documented using Swagger. You can access the documentation by navigating to `http://localhost:3000/api` after starting the backend service.

### Key Middleware and Security Features

- **Helmet**: Adds security headers to HTTP responses.
- **Rate Limiting**: Limits the number of requests per IP to prevent abuse.
- **Content Security Policy (CSP)**: Restricts resource loading to enhance security.

## Git Submodules

This project uses Git submodules for the backend and frontend:

```git
[submodule "backend"]
    path = backend
    url = https://github.com/Ahmdfdhilah/okocnetbackend
[submodule "frontend"]
    path = frontend
    url = https://github.com/Ahmdfdhilah/okocnetfrontend
```

## Database Backup

The application is configured with a backup database to ensure data redundancy and reliability. This is managed using two separate MariaDB containers:

- **db**: The primary MariaDB database service.
- **db_backup**: The backup MariaDB database service.

Both databases are defined in the `docker-compose.yml` file, and each has its own volume for persistent storage. The backup database serves as a failover solution to prevent data loss in case of issues with the primary database.

By setting up these two database services, we ensure that there is always a backup available, minimizing the risk of data loss and enhancing the reliability of the application.

## Redis Usage

The application utilizes Redis for caching and improving performance. Specifically, it uses Upstash Redis, a serverless Redis solution that offers low latency and high availability. Here's how Redis is integrated into the backend:

1. **Installation**: Ensure the `@upstash/redis` package is installed in your NestJS application.

```bash
npm install @upstash/redis
```

2. **Configuration**: Configure Redis connection settings using Upstash environment variables.

3. **Usage**: Implement caching strategies in your services to store frequently accessed data in Redis, reducing the load on your database and speeding up response times.

### Configuration

Create a Redis client using Upstash Redis:

```typescript
import { Redis } from '@upstash/redis';

const redis = new Redis({
  url: process.env.UPSTASH_REDIS_REST_URL,
  token: process.env.UPSTASH_REDIS_REST_TOKEN,
});

export default redis;
```

### Usage

Use Redis in your services:

```typescript
import redis from './redis-client';

class CacheService {
  async setCache(key: string, value: any) {
    await redis.set(key, JSON.stringify(value), { ex: 3600 }); // Cache for 1 hour
  }

  async getCache(key: string) {
    const data = await redis.get(key);
    return data ? JSON.parse(data) : null;
  }
}

export default new CacheService();
```

By integrating Upstash Redis, you can enhance the performance and scalability of your application through efficient caching mechanisms.

## Conclusion

Follow these instructions to set up and run the OK OCE NET application. For any issues, please refer to the documentation or the GitHub issues page for assistance or hit me up at whatsapp 089647107815.
