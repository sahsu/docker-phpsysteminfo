FROM alpine:latest
MAINTAINER Stephen Packer <steve@stevepacker.com>

ENV HOME=/root

# install s6 supervisor
RUN cd /tmp \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v1.10.0.3/s6-overlay-amd64.tar.gz \
    && tar xzf s6-overlay-amd64.tar.gz -C /
CMD ["/init"]

COPY remote_syslog.s6 /etc/services.d/remote_syslog/run

VOLUME ["/etc/log_files.yml"]

ENV PAPERTRAIL_VERSION 0.14
ENV PAPERTRAIL_URL https://github.com/papertrail/remote_syslog2/releases/download/v$PAPERTRAIL_VERSION/remote_syslog_linux_amd64.tar.gz
RUN mkdir -p /opt \
    && cd /opt \
    && curl -LOs $PAPERTRAIL_URL \
    && tar xfz remote_syslog_linux_amd64.tar.gz \
    && rm remote_syslog_linux_amd64.tar.gz \
    && mv remote_syslog /usr/local/bin

