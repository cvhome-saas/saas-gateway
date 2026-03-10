# Stage 1: Build custom Caddy using xcaddy
FROM golang:1.24-alpine AS builder

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build Caddy with the required plugins
# The 'xcaddy build' command will automatically use the correct platform-specific Go compiler.
RUN xcaddy build \
    --with github.com/cvhome-saas/certmagic-s3 \
    --with github.com/cvhome-saas/caddy-domainlookup

# Stage 2: Final minimal image
FROM alpine:3.21

# Install runtime dependencies (like CA certificates)
RUN apk add --no-cache ca-certificates libcap

# Copy the custom Caddy binary from the builder stage
COPY --from=builder /go/caddy /usr/bin/caddy

# Ensure Caddy has permissions to bind to privileged ports (optional but recommended)
RUN setcap cap_net_bind_service=+ep /usr/bin/caddy

# Set entrypoint
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]