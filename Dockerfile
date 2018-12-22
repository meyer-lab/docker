FROM alpine:3.8
MAINTAINER Aaron S Meyer

ENV PERSISTENT_DEPS clang python3 valgrind zlib
ENV BUILD_DEPS alpine-sdk cabal cmake zlib-dev

RUN apk upgrade --update && \
    apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS

# Create Pandoc build space
RUN mkdir -p /sundials-build
WORKDIR /sundials-build

RUN wget https://computation.llnl.gov/projects/sundials/download/sundials-4.0.1.tar.gz && \
    tar -xf sundials-4.0.1.tar.gz

WORKDIR /sundials-build/sundials-4.0.1
RUN mkdir -p build
WORKDIR /sundials-build/sundials-4.0.1/build
RUN cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_C_FLAGS="-O3 -mtune=native" -DEXAMPLES_ENABLE_C=OFF
RUN make && make install

WORKDIR /

RUN rm -rf /sundials-build

RUN pip3 install --no-cache-dir numpy scipy hypothesis matplotlib seaborn tensorly

RUN apk del .build-deps
