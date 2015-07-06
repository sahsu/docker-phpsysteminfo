FROM alpine:latest
MAINTAINER Stephen Packer <steve@stevepacker.com>

ENV HOME=/root

# install packages
RUN apk --update --no-progress add \
        nginx git vim curl openssl \
        php-cli php-fpm php-mcrypt php-curl php-gd php-json php-intl php-openssl \
        php-pdo_mysql php-pdo_sqlite php-phar php-imap php-iconv php-dom \
        php-phalcon php-zip php-zlib php-bz2 php-ctype php-sockets php-posix \
	&& rm -rf /var/cache/apk/*

# install s6 supervisor
ENV S6_VERSION 1.13.0.0
RUN cd /tmp \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/s6-overlay-amd64.tar.gz \
    && tar xzf s6-overlay-amd64.tar.gz -C /
CMD ["/init"]

# move files into their respective places
COPY build /root/build/
RUN	mkdir -p /etc/services.d/nginx /var/www \
	&& mv /root/build/nginx.s6       /etc/services.d/nginx/run \
	&& mkdir -p /etc/services.d/php-fpm \
	&& mv /root/build/php-fpm.s6     /etc/services.d/php-fpm/run \
	&& mv /root/build/php-fpm.ini    /etc/php/php.ini \
	&& mv /root/build/php-fpm.conf   /etc/php/php-fpm.conf \
	&& ln -s /dev/stdout /var/log/nginx/access.log \
	&& ln -s /dev/stderr /var/log/nginx/error.log

WORKDIR /var/www

VOLUME ["/var/www"]

EXPOSE 80 443
