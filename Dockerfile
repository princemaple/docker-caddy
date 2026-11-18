FROM caddy:2.11.9-builder AS builder

ARG DNS

RUN xcaddy build \
    --with github.com/caddy-dns/$DNS \
    --with github.com/caddyserver/caddy/v2=github.com/caddyserver/caddy/v2@v2.11.2

FROM caddy:2.11.9

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
