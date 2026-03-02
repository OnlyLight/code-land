FROM node:20-alpine

# Tạo user non-root
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

RUN chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 3000

CMD ["npm", "start"]
