FROM alpine:3.8
MAINTAINER Aaron S Meyer

ENV PERSISTENT_DEPS build-base python3 valgrind git freetype openblas py3-scipy py3-numpy llvm5
ENV BUILD_DEPS cmake python3-dev freetype-dev openblas-dev py-numpy-dev llvm5-dev

RUN apk upgrade --update && \
    apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS

# Create sundials build space
RUN mkdir -p /sundials-build
WORKDIR /sundials-build

RUN wget https://computation.llnl.gov/projects/sundials/download/sundials-4.0.1.tar.gz && \
    tar -xf sundials-4.0.1.tar.gz

WORKDIR /sundials-build/sundials-4.0.1
RUN mkdir -p build
WORKDIR /sundials-build/sundials-4.0.1/build
RUN cmake .. -DBUILD_SHARED_LIBS=ON \
	-DBUILD_ARKODE=OFF -DBUILD_IDAS=OFF -DBUILD_KINSOL=OFF -DBUILD_IDA=OFF \
	-DCMAKE_C_FLAGS="-O3 -mtune=native" -DEXAMPLES_ENABLE_C=OFF
RUN make -j 20 && make install

WORKDIR /

RUN rm -rf /sundials-build

RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir --prefer-binary hypothesis matplotlib seaborn tensorly numba

RUN apk del .build-deps
