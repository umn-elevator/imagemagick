FROM        ubuntu:18.04 as base

FROM        base as build
WORKDIR     /tmp/workdir

RUN     apt-get -yqq update && \
        apt-get --no-install-recommends -yqq install software-properties-common && \
        rm -rf /var/lib/apt/lists/*

RUN     BUILD_PACKAGES='curl unzip make autoconf automake cmake g++ gcc build-essential' && \
        add-apt-repository ppa:strukturag/libheif && \
        apt-get -yqq update && \
        apt-get --no-install-recommends -yqq install $BUILD_PACKAGES && \
        apt-get -y install --no-install-recommends libde265-dev libheif1 libheif-dev libopenjp2-7-dev libjbig-dev libtiff5-dev libpng16-16 libpng-dev libjpeg-turbo8 libjpeg-turbo8-dev libjbig2dec0 libwebp6 libwebp-dev libgomp1 libwebpmux3 pkg-config libbz2-dev && \
        DIR=/tmp/imagemagick && \
        mkdir -p ${DIR} && \
        cd ${DIR} && \
        curl -L -o ${DIR}/7.0.8-39.tar.gz https://github.com/ImageMagick/ImageMagick/archive/7.0.8-39.tar.gz && \
        tar -zxvf ${DIR}/7.0.8-39.tar.gz  && \
        cd ${DIR}/ImageMagick-7.0.8-39 && \
        ./configure --with-heic && \
        make -j4 && \
        make install && \
        rm -rf ${DIR}

FROM base as release

WORKDIR     /tmp/workdir

RUN     apt-get -yqq update && \
        apt-get --no-install-recommends -yqq install software-properties-common && \
        rm -rf /var/lib/apt/lists/*

RUN     add-apt-repository ppa:strukturag/libheif && \
    apt-get -y install --no-install-recommends libjbig2dec0 libde265-0 libheif1 libpng16-16 libopenjp2-7 libjbig0 libtiff5 libjpeg-turbo8 libwebp6 libgomp1 libwebpmux3 libbz2-1.0 ghostscript && \
        rm -rf /var/lib/apt/lists/*

COPY        --from=build /usr/local/bin /usr/local/bin
COPY        --from=build /usr/local/lib /usr/local/lib
COPY        --from=build /usr/local/etc /usr/local/etc

MAINTAINER  Colin McFadden <mcfa0086@umn.edu>
ENV     LD_LIBRARY_PATH=/usr/local/lib
ENV     MAGICK_TMPDIR=/scratch