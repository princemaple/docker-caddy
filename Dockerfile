FROM caddy:2.6.4-builder AS builder

ARG DNS

RUN caddy-builder \
    github.com/caddy-dns/$DNS

FROM caddy:2.6.4

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
