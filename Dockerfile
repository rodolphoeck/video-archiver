# https://hub.docker.com/_/alpine
FROM alpine:3.21

# https://github.com/Yelp/dumb-init/releases
ARG DUMB_INIT_VERSION=1.2.5

# https://github.com/yt-dlp/yt-dlp/releases
ARG BUILD_VERSION=2025.01.26

RUN set -x \
 && apk update \
 && apk upgrade -a \
 && apk add --no-cache \
        ca-certificates \
        curl \
        dumb-init \
        ffmpeg \
        python3 \
        py3-mutagen \
 && curl -Lo /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/download/${BUILD_VERSION}/yt-dlp \
 && chmod a+rx /usr/local/bin/yt-dlp \
 && apk del curl \
 && mkdir /downloads \
 && chmod a+rw /downloads \
 && mkdir /.cache \
 && chmod 777 /.cache

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV YT_COOKIES_PATH=/cookie/cookies.file

COPY run.sh /

RUN chmod 777 /run.sh

WORKDIR /downloads

VOLUME ["/downloads"]

VOLUME ["/cookies"]

RUN dumb-init yt-dlp --version

ENTRYPOINT ["dumb-init", "/run.sh"]
CMD ["--help"]
