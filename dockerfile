# Etapa de construcción
FROM node:14 as builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Etapa de producción
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
# Modifica tu Dockerfile para manejar mejor los errores:
FROM node:14 as builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production  # Usa npm ci para instalaciones más confiables
COPY . .
RUN npm run build
# Aumenta memoria disponible para Node
FROM node:14 as builder
WORKDIR /app
ENV NODE_OPTIONS="--max-old-space-size=4096"
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build
