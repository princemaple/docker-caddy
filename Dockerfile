FROM golang:1.9-alpine as builder

ARG version="0.10.10"

RUN apk add --no-cache git

RUN git clone https://github.com/mholt/caddy \
      -b "v${version}" /go/src/github.com/mholt/caddy

ARG plugins

RUN go get -v github.com/abiosoft/caddyplug/caddyplug

RUN for plugin in $(echo $plugins | tr "," " "); do \
    go get -v $(caddyplug package $plugin); \
    printf "package caddyhttp\nimport _ \"$(caddyplug package $plugin)\"" > \
        /go/src/github.com/mholt/caddy/caddyhttp/$plugin.go ; \
    done

RUN git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds
RUN cd /go/src/github.com/mholt/caddy/caddy \
    && git checkout -f \
    && go run build.go \
    && mv caddy /go/bin


FROM alpine:3.6

ARG deps

LABEL caddy_version="0.10.10"

RUN apk add --no-cache $deps \
    && rm -rf /var/cache/apk

COPY --from=builder /go/bin/caddy /usr/bin/caddy

RUN /usr/bin/caddy -version \
    && /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]
