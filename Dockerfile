FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive

ENV CFLAGS="-Os -pipe -fstack-protector-strong"
ENV LDFLAGS="-Wl,-O1,--sort-common -Wl,-s"

RUN apt-get update  -qy && \
    apt-get install -qy \
        build-essential linux-libc-dev \
        curl gawk tar bzip2 ncompress xz-utils

WORKDIR /tmp
