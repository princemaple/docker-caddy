FROM caddy:2.6.0-builder AS builder

ARG DNS

RUN caddy-builder \
    github.com/caddy-dns/$DNS

FROM caddy:2.6.0

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
