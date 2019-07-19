openwrt-snapshot-builder
========================
[![Docker Build Status](https://img.shields.io/docker/build/iganesh/openwrt-snapshot-builder.svg)](https://hub.docker.com/r/iganesh/openwrt-snapshot-builder)
[![License: MIT](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://img.shields.io/docker/build/iganeshk/openwrt-snapshot-builder-docker/blob/master/LICENSE)


This is a docker container for the [OpenWRT](https://openwrt.org/)
[buildroot](http://wiki.openwrt.org/doc/howto/buildroot.exigence).

Because the build system requires that its command are not executed by root,
the user `openwrt` was created. The buildroot can be found in
`/home/openwrt/openwrt`.

To run a shell in the buildroot, execute the following command:
```sh
docker run -it iganesh/openwrt-snapshot-builder
```

More information on how to use this buildroot can be found on the
[OpenWRT wiki](http://wiki.openwrt.org/doc/howto/build).