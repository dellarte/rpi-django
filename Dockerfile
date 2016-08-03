FROM resin/rpi-raspbian
MAINTAINER Gavin Adam <gavinadam80@gmail.com>

ENV DJANGO_VER 1.9.7

RUN apt-get update && apt-get install -y \
    ca-certificates \
    wget \
    python3 \
    python3-pip \
    python3-dev \
    git \
    libcurl4-openssl-dev \
    libc-ares-dev \
    libssl-dev \
    libcrypto++-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libfreeimage-dev \
    libpthread-stubs0-dev \
    libreadline-dev \
    swig \
    g++ \
    dh-autoreconf \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /data/sdk

WORKDIR /data/sdk

RUN git clone https://github.com/meganz/sdk.git /data/sdk && \
    ./autogen.sh && \
    ./configure --disable-silent-rules --enable-python --with-python3 --disable-examples && \
    make && \
    make install

WORKDIR /data/sdk/bindings/python

RUN pip3 install wheel && \
    python3 setup.py bdist_wheel && \
    pip3 install dist/megasdk-2.6.0-py2.py3-none-any.whl && \
    cp -r /data/sdk/bindings/python/build/lib/mega /usr/lib/python3/dist-packages/ && \
    pip3 install Django==$DJANGO_VER

WORKDIR /data

VOLUME /data

EXPOSE 80
CMD [ "python3", "manage.py", "runserver", "0.0.0.0:80"]
