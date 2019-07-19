FROM debian:10
LABEL maintainer "Ganesh Velu <iganeshk@users.noreply.github.com>"

RUN set -eux; \
    echo "deb http://ftp.us.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends   \
               ca-certificates wget less nano gosu \
               subversion g++ zlib1g-dev build-essential git python rsync \
               libncurses5-dev gawk gettext unzip file libssl-dev wget \
               bsdmainutils util-linux; \
    apt-get autoclean; \
    apt-get clean; \
    apt-get autoremove; \
    rm -rf /var/lib/apt/lists/*; \
    # verify that the binary works
    gosu nobody true

RUN mkdir -p /openwrt

WORKDIR "/openwrt"

ADD usr/local/bin /usr/local/bin/
ADD home/ /openwrt

RUN chmod 755 /usr/local/bin/entrypoint.sh 

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
