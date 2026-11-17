# Stage 1: Build the React/Vite application
FROM node:18-alpine AS builder

WORKDIR /app

# Accept backend API URL as build argument
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Copy package manifests and install dependencies
COPY package*.json ./
RUN npm install

# Copy application source code and build production bundle
COPY . .
RUN npm run build

# Stage 2: Serve production assets with high-performance Nginx Alpine
FROM nginx:alpine

# Copy compiled static assets from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose web server port
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
