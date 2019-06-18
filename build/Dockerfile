FROM alpine:edge
MAINTAINER Aaron S Meyer

USER root

ENV PERSISTENT_DEPS build-base python3 valgrind git freetype openblas eigen eigen-dev bash openssl
ENV BUILD_DEPS cmake freetype-dev openblas-dev

RUN apk upgrade --update && \
    apk add --no-cache $PERSISTENT_DEPS && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS

RUN pip3 install --no-cache-dir --upgrade pip virtualenv

# Build sundials
RUN mkdir -p /sundials-build
WORKDIR /sundials-build

RUN wget https://computation.llnl.gov/projects/sundials/download/sundials-4.1.0.tar.gz && \
    tar -xf sundials-4.1.0.tar.gz

WORKDIR /sundials-build/sundials-4.1.0
RUN mkdir -p build
WORKDIR /sundials-build/sundials-4.1.0/build
RUN cmake .. -DBUILD_SHARED_LIBS=ON \
	-DBUILD_ARKODE=OFF -DBUILD_IDAS=OFF -DBUILD_KINSOL=OFF -DBUILD_IDA=OFF \
	-DCMAKE_C_FLAGS="-O3 -mtune=native" -DEXAMPLES_ENABLE_C=OFF
RUN make -j 20 && make install

WORKDIR /

RUN rm -rf /sundials-build

RUN apk del .build-deps

RUN adduser -D jenkins
USER jenkins

USER root
