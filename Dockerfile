ARG DEBIAN_TAG
FROM debian:$DEBIAN_TAG

ENV DEBIAN_FRONTEND=noninteractive

ENV CFLAGS="-Os -pipe -fstack-protector-strong -D_GNU_SOURCE=1" \
    CXXFLAGS="-Os -pipe -fstack-protector-strong -D_GNU_SOURCE=1" \
    LDFLAGS="-Wl,-O1,--sort-common -Wl,-s"

# Create a default output directory
RUN mkdir /output

RUN apt-get update  -qy && \
    apt-get install -qy \
        build-essential linux-libc-dev \
        autoconf automake libtool pkg-config \
        git curl gawk tar bzip2 ncompress xz-utils tree

# Override shell for bash-y debugging goodness
SHELL ["/bin/bash", "-exc"]

WORKDIR /tmp
