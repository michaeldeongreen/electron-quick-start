FROM node:latest

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libgtk2.0-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2-dev \
    xserver-xorg-video-dummy

WORKDIR /usr/src/app

RUN npm install electron -g --unsafe-perm=true --allow-root

COPY . .

RUN chmod +x entry.sh

CMD ["/bin/bash","./entry.sh"]