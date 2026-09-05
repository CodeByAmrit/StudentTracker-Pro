# Stage 1: Build the application
FROM node:24.20.0-alpine AS builder

WORKDIR /school

# Fix for Sharp compatibility
RUN apk add --no-cache libc6-compat

# Install all dependencies and build CSS
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Prune dev dependencies so we only copy production dependencies to Stage 2
RUN npm prune --omit=dev

# Stage 2: Production image
FROM node:24.20.0-alpine

WORKDIR /school

ENV NODE_ENV=production

# Install libc6-compat in runtime as well if required by sharp
RUN apk add --no-cache libc6-compat

# Copy production dependencies and built files
COPY --from=builder /school/package*.json ./
COPY --from=builder /school/node_modules ./node_modules
COPY --from=builder /school/bin ./bin
COPY --from=builder /school/app.js ./
COPY --from=builder /school/routes ./routes
COPY --from=builder /school/controllers ./controllers
COPY --from=builder /school/middleware ./middleware
COPY --from=builder /school/models ./models
COPY --from=builder /school/services ./services
COPY --from=builder /school/views ./views
COPY --from=builder /school/public ./public
COPY --from=builder /school/config ./config
COPY --from=builder /school/template ./template

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Fix permissions for runtime
RUN chown -R appuser:appgroup /school

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:5000/health || exit 1

CMD ["node", "bin/www"]