FROM golang:alpine AS BUILDER

RUN apk add git && go get -u github.com/caddyserver/xcaddy/cmd/xcaddy \
    && xcaddy build v2.1.1 --with github.com/caddy-dns/cloudflare

FROM alpine:3.12

WORKDIR /var/caddy

COPY --from=BUILDER /go/caddy /bin

ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

VOLUME /config
VOLUME /data

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
