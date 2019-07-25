openwrt-snapshot-builder
========================
![snapshot-builder 0.1](https://img.shields.io/badge/snapshot--builder-0.1-success.svg?style=flat-square)
[![Build Status](https://travis-ci.com/iganeshk/openwrt-snapshot-builder-docker.svg?branch=master)](https://travis-ci.com/iganeshk/openwrt-snapshot-builder-docker)
![Docker Pulls](https://img.shields.io/docker/pulls/iganesh/openwrt-snapshot-builder.svg?style=flat-square)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)

This is a docker container for the [OpenWRT](https://openwrt.org/)
[buildroot](http://wiki.openwrt.org/doc/howto/buildroot.exigence).

Because the build system requires that its command are not executed by root,
the user `openwrt` was created. The buildroot can be found in `/home/openwrt/openwrt`.

To build a OpenWRT snpashot image, execute the following script:
```sh
wget https://raw.githubusercontent.com/iganeshk/openwrt-snapshot-builder-docker/master/openwrt_docker_buildroot.sh && bash openwrt_docker_buildroot.sh
```

* The following script, clones OpenWRT git repository and tries to build based on the configuration file present, if you not you will be asked to make one (menuconfig). 

or to just run the container, run the following command:
```sh
docker run -it iganesh/openwrt-snapshot-builder
```

More information on how to use this buildroot can be found on the
[OpenWRT wiki](http://wiki.openwrt.org/doc/howto/build).