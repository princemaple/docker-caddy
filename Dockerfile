FROM golang:alpine AS BUILDER

RUN apk add git && go get -u github.com/caddyserver/xcaddy/cmd/xcaddy \
    && xcaddy build v2.0.0 --with github.com/libdns/cloudflare

FROM alpine:3.12

WORKDIR /var/caddy

COPY --from=BUILDER /go/caddy /bin

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
