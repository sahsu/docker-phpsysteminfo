FROM alpine:latest
MAINTAINER Stephen Packer <steve@stevepacker.com>
EXPOSE 80

ENV HOME=/root

# install packages
RUN apk --update --no-progress add php php-xml php-dom openssl \
	&& rm -rf /var/cache/apk/*

# install s6 supervisor
RUN cd /tmp \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v1.10.0.3/s6-overlay-amd64.tar.gz \
    && tar xzf s6-overlay-amd64.tar.gz -C /
CMD ["/init"]

COPY phpsysinfo.s6 /etc/services.d/phpsysinfo/run
COPY beforeRun.sh /beforeRun.sh

RUN /beforeRun.sh