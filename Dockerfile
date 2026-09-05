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
# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --chown=appuser:appgroup --from=builder /school/package*.json ./
COPY --chown=appuser:appgroup --from=builder /school/node_modules ./node_modules
COPY --chown=appuser:appgroup --from=builder /school/bin ./bin
COPY --chown=appuser:appgroup --from=builder /school/app.js ./
COPY --chown=appuser:appgroup --from=builder /school/routes ./routes
COPY --chown=appuser:appgroup --from=builder /school/controllers ./controllers
COPY --chown=appuser:appgroup --from=builder /school/middleware ./middleware
COPY --chown=appuser:appgroup --from=builder /school/models ./models
COPY --chown=appuser:appgroup --from=builder /school/services ./services
COPY --chown=appuser:appgroup --from=builder /school/views ./views
COPY --chown=appuser:appgroup --from=builder /school/public ./public
COPY --chown=appuser:appgroup --from=builder /school/config ./config
COPY --chown=appuser:appgroup --from=builder /school/template ./template

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:5000/health || exit 1

CMD ["node", "bin/www"]