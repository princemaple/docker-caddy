FROM caddy:2.5.1-builder AS builder

RUN caddy-builder \
    github.com/caddy-dns/cloudflare

FROM caddy:2.5.1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
