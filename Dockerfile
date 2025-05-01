FROM alpine:3.19

COPY caddy /usr/bin/caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]