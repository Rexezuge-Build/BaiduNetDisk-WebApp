FROM alpine:3

ARG BAIDUNETDISK_VER=4.17.7

RUN apk add --no-cache wget

RUN wget https://issuepcdn.baidupcs.com/issue/netdisk/LinuxGuanjia/${BAIDUNETDISK_VER}/baidunetdisk_${BAIDUNETDISK_VER}_amd64.deb -O baidunetdisk.deb

FROM jlesage/baseimage-gui:debian-11

COPY --from=0 /baidunetdisk.deb /baidunetdisk.deb

COPY overlay/ /

RUN apt update \
 && apt upgrade -y --no-install-recommends \

 && apt install -y --no-install-recommends \
    libgtk-3-0 libnotify4 libnss3 libxss1 xdg-utils libatspi2.0-0 libsecret-1-0 \
    libgbm1 libasound2 ttf-wqy-zenhei \

 && dpkg -i /baidunetdisk.deb \
 && rm /baidunetdisk.deb \

 && apt clean autoclean \
 && apt autoremove -y --purge \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV APP_NAME="BaiduNetDisk" \
    NOVNC_LANGUAGE="en_US" \
    TZ=America/New_York

VOLUME ["/config/downloads", "/config/.config"]
