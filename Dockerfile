# Stage 1: Build custom Caddy
FROM golang:1.25-alpine AS builder

WORKDIR /build

RUN apk add --no-cache git

# install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
ENV PATH="/go/bin:${PATH}"

# build caddy with plugins
RUN xcaddy build \
    --output /build/caddy \
    --with github.com/cvhome-saas/certmagic-s3 \
    --with github.com/cvhome-saas/caddy-domainlookup


# Stage 2: runtime image
FROM alpine:3.19

RUN apk add --no-cache ca-certificates libcap

COPY --from=builder /build/caddy /usr/bin/caddy

RUN setcap cap_net_bind_service=+ep /usr/bin/caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]