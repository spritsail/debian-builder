[hub]: https://hub.docker.com/r/spritsail/debian-builder
[git]: https://github.com/spritsail/debian-builder
[drone]: https://drone.spritsail.io/spritsail/debian-builder

# [spritsail/debian-builder][hub]

[![](https://images.microbadger.com/badges/image/spritsail/debian-builder.svg)](https://microbadger.com/images/spritsail/debian-builder)
[![Latest Version](https://images.microbadger.com/badges/version/spritsail/debian-builder.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/spritsail/debian-builder.svg)][git]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/debian-builder.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/debian-builder.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/debian-builder/status.svg)][drone]

## Example usage

```Dockerfile
FROM spritsail/debian-builder as builder

ARG BUSYBOX_VER=1.27.1

# Download and build busybox from source
RUN curl -fL https://busybox.net/downloads/busybox-${BUSYBOX_VER}.tar.bz2 \
        | tar xj --strip-components=1 && \
    # Use default configuration
    make defconfig && \
    make -j "$(nproc)" && \
    ...

#~~~~~~~~~~~~~~~~

FROM scratch
COPY --from=builder /tmp/busybox /
CMD ["/busybox", "sh"]
```
