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
