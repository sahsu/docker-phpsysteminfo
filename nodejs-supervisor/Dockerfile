FROM alpine:3.2
MAINTAINER Stephen Packer <steve@stevepacker.com>

WORKDIR /app
VOLUME ["/app"]

RUN apk -U add nodejs openssl \
    && rm -rf /var/cache/apk/* \
    && npm install -g supervisor \
    && adduser -D -u 1000 node \
    && chown -Rf node /app

USER node