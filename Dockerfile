# Stage 1: Build the React frontend
FROM node:16 as build-frontend
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Build the NestJS backend
FROM node:16 as build-backend
WORKDIR /app
COPY backend/package.json backend/package-lock.json ./
RUN npm install
COPY backend/ ./
COPY --from=build-frontend /app/build ./public
RUN npm run build

# Stage 3: Run the application
FROM node:16-alpine
WORKDIR /app
COPY --from=build-backend /app ./
EXPOSE 3000
CMD ["node", "dist/main"]