FROM caddy:2.9.1-builder AS builder

ARG DNS

RUN xcaddy build \
    --with github.com/caddy-dns/$DNS \
    --with github.com/caddyserver/caddy/v2=github.com/caddyserver/caddy/v2@v2.9.1

FROM caddy:2.9.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
