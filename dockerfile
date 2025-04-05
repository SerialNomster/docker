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
# Especifica explícitamente el contexto de copia
FROM node:14 as builder
WORKDIR /app

# Primero copia solo los archivos del package
COPY package*.json ./  # Nota el uso del patrón package*.json

# Luego instala dependencias
RUN npm install

# Finalmente copia todo lo demás
COPY . .

# Ejecuta el build
RUN npm run build
# Modifica temporalmente tu Dockerfile para copiar archivos individualmente
FROM node:14
WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
