ARG DEBIAN_TAG
FROM debian:$DEBIAN_TAG

ENV DEBIAN_FRONTEND=noninteractive

ENV CFLAGS="-Os -pipe -fstack-protector-strong" \
    CXXFLAGS="-Os -pipe -fstack-protector-strong" \
    LDFLAGS="-Wl,-O1,--sort-common -Wl,-s"

RUN apt-get update  -qy && \
    apt-get install -qy \
        build-essential linux-libc-dev \
        autoconf automake libtool pkg-config \
        git curl gawk tar bzip2 ncompress xz-utils

# Override shell for bash-y debugging goodness
SHELL ["/bin/bash", "-exc"]

WORKDIR /tmp
