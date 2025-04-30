FROM alpine:3.19

COPY caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile

ENV HOST 0.0.0.0

EXPOSE 80
EXPOSE 443
EXPOSE 2019
#CMD ["caddy", "list-modules"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]