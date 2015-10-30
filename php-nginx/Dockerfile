FROM phusion/baseimage:latest
MAINTAINER Stephen Packer <stephen.packer@wemonitorhome.com>
EXPOSE 80 443

ENV HOME=/root

CMD ["/sbin/my_init"]

# install php5.6 PPA, packages, upgrade security packages, and cleanup
#echo "deb http://ppa.launchpad.net/ondrej/php-7.0/ubuntu trusty main" > /etc/apt/sources.list.d/ondrej-php5-7-trusty.list \
RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" > /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    ; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
        nginx git vim curl openssl \
        php5-cli php5-fpm php5-curl php5-mcrypt php5-json php5-intl \
        php5-imap php5-xdebug php5-redis php5-mysql php5-mongo \
    && apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# install composer
RUN cd /root \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir -p /root/.composer


# install yii2 global dependency
RUN cd /tmp && composer global require "fxp/composer-asset-plugin:1.0.3"


# move files into their respective places
COPY build /root/build/
RUN    mkdir -p /etc/service/php-fpm /etc/service/nginx \
    && mv /root/build/php-fpm.service /etc/service/php-fpm/run \
    && chmod 0755 /etc/service/php-fpm/run \
    && mv /root/build/nginx.service /etc/service/nginx/run \
    && chmod 0755 /etc/service/nginx/run \
    && mv /root/build/git-clone.sh /etc/my_init.d/git-clone.sh \
    && chmod 0755 /etc/my_init.d/git-clone.sh \
    && echo "extension=mcrypt.so"   > /etc/php5/cli/conf.d/20-mcrypt.ini \
    && echo "extension=mcrypt.so"   > /etc/php5/fpm/conf.d/20-mcrypt.ini \
    && echo "extension=imap.so"     > /etc/php5/cli/conf.d/20-imap.ini \
    && echo "extension=imap.so"     > /etc/php5/fpm/conf.d/20-imap.ini

