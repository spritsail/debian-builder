[hub]: https://hub.docker.com/r/frebib/debian-builder

# [frebib/debian-builder][hub] - Build multi-stage images easier
[![](https://images.microbadger.com/badges/image/frebib/debian-builder.svg)](https://microbadger.com/images/frebib/debian-builder) [![](https://images.microbadger.com/badges/version/frebib/debian-builder.svg)][hub] [![Docker Stars](https://img.shields.io/docker/stars/frebib/debian-builder.svg)][hub] [![Docker Pulls](https://img.shields.io/docker/pulls/frebib/debian-builder.svg)][hub] [![Build Status](https://drone.adam-ant.co.uk/api/badges/frebib/docker-debian-builder/status.svg)](https://drone.adam-ant.co.uk/frebib/docker-debian-builder)

## Example usage

```Dockerfile
FROM frebib/debian-builder as builder

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
