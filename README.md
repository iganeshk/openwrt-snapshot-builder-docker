openwrt-snapshot-builder
========================
![snapshot-builder 0.1](https://img.shields.io/badge/snapshot--builder-0.1-success.svg?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/iganesh/openwrt-snapshot-builder.svg?style=flat-square)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)

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