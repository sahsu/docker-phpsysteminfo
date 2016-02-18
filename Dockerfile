FROM alpine:latest
MAINTAINER Stephen Packer <steve@stevepacker.com>
EXPOSE 80 443

ENV HOME=/root

# install packages
RUN apk --update --no-progress add \
		nginx git vim curl openssl samba-client \
		php-fpm php-json php-mysql php-curl php-xml php-iconv php-ctype php-dom \
        php-gd php-ftp php-posix php-zip php-zlib php-bz2 php-openssl php-mcrypt \
		php-pdo_mysql php-pdo_sqlite php-sqlite3 \
	&& rm -rf /var/cache/apk/*

# install s6 supervisor
ENV S6_VERSION 1.13.0.0
RUN cd /tmp \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/s6-overlay-amd64.tar.gz \
    && tar xzf s6-overlay-amd64.tar.gz -C /
CMD ["/init"]

# install owncloud
ENV OWNCLOUD_VERSION 8.2.2
ENV OWNCLOUD_PACKAGE owncloud-$OWNCLOUD_VERSION.tar.bz2
ENV OWNCLOUD_URL https://download.owncloud.org/community/$OWNCLOUD_PACKAGE
RUN mkdir -p /opt \
    && cd /opt \
    && curl -LOs $OWNCLOUD_URL \
    && tar xjf $OWNCLOUD_PACKAGE \
    && rm $OWNCLOUD_PACKAGE \
    && mkdir -p /opt/owncloud/config /opt/owncloud/data \
    && chmod 0770 /opt/owncloud/data

# move files into their respective places
COPY build /root/build/
RUN	mkdir -p /etc/services.d/nginx \
	&& ln -s /bin/true /etc/services.d/nginx/finish \
	&& mv /root/build/nginx.s6       /etc/services.d/nginx/run \
	&& mv /root/build/nginx.conf     /etc/nginx/nginx.conf \
	&& mkdir -p /etc/services.d/php-fpm \
	&& ln -s /bin/true /etc/services.d/php-fpm/finish \
	&& mv /root/build/php-fpm.s6     /etc/services.d/php-fpm/run \
	&& mv /root/build/php-fpm.ini    /etc/php/php.ini \
	&& mv /root/build/php-fpm.conf   /etc/php/php-fpm.conf \
	&& ln -s /dev/stdout /var/log/nginx/access.log \
	&& ln -s /dev/stderr /var/log/nginx/error.log

WORKDIR /opt/owncloud

VOLUME ["/opt/owncloud/config", "/opt/owncloud/data"]

EXPOSE 80 443
