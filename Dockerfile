FROM alpine:3.19

RUN apk add --no-cache caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
