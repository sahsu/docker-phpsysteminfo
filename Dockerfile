FROM phusion/baseimage:latest
MAINTAINER Stephen Packer <steve@stevepacker.com>

# install php5.6 PPA, packages, upgrade security packages, and cleanup
#echo "deb http://ppa.launchpad.net/ondrej/php-7.0/ubuntu trusty main" > /etc/apt/sources.list.d/ondrej-php5-7-trusty.list \
RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" > /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    ; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
        git vim curl openssl busybox \
        php5-cli php5-curl php5-mcrypt php5-json php5-intl \
        php5-imap php5-redis php5-mysql php5-mongo php5-sqlite \
    && apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# install composer
RUN cd /root \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir -p /root/.composer


# move files into their respective places, but disabling xdebug
RUN    echo "extension=mcrypt.so"     > /etc/php5/cli/conf.d/20-mcrypt.ini \
    && echo "extension=imap.so"       > /etc/php5/cli/conf.d/20-imap.ini \
    && echo "date.timezone = \"UTC\"" > /etc/php5/cli/conf.d/30-utc-timezone.ini

