FROM caddy:2.10.0-builder AS builder

ARG DNS

RUN xcaddy build \
    --with github.com/caddy-dns/$DNS \
    --with github.com/caddyserver/caddy/v2=github.com/caddyserver/caddy/v2@v2.10.0

FROM caddy:2.10.0

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
