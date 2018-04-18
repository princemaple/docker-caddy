FROM abiosoft/caddy:builder as builder

ARG version="0.10.13"
ARG plugins="filemanager cache"

RUN VERSION=${version} PLUGINS=${plugins} /bin/sh /usr/bin/builder.sh


FROM alpine:3.7

LABEL caddy_version="0.10.13"

RUN apk add --no-cache openssh-client ca-certificates

COPY --from=builder /install/caddy /usr/bin/caddy

RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]
