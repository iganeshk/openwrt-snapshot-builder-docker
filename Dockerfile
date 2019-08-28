FROM debian:10
LABEL maintainer "Ganesh Velu <iganeshk@users.noreply.github.com>"

RUN set -eux; \
    echo "deb http://ftp.us.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends   \
               apt-utils ca-certificates wget less nano gosu \
               subversion g++ zlib1g-dev build-essential git python python3 rsync \
               libncurses5-dev gawk gettext unzip file libssl-dev wget \
               bsdmainutils sudo; \
    apt-get autoclean; \
    apt-get clean; \
    apt-get autoremove; \
    rm -rf /var/lib/apt/lists/*; \
    # verify that the binary works
    gosu nobody true

RUN useradd -ms /bin/bash openwrt; \
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt;

USER openwrt
WORKDIR "/home/openwrt"
ADD home/openwrt/snapshot_builder.sh /home/openwrt
RUN sudo chown openwrt:openwrt /home/openwrt/snapshot_builder.sh
RUN sudo chmod 755 /home/openwrt/snapshot_builder.sh

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
