FROM alpine:3.8
MAINTAINER Aaron S Meyer

ENV PERSISTENT_DEPS clang python3 valgrind ruby
ENV BUILD_DEPS alpine-sdk ghc cabal cmake zlib zlib-dev

RUN apk upgrade --update && \
    apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS

RUN cabal update

RUN cabal install pandoc-crossref pandoc-citeproc

# Create Pandoc build space
RUN mkdir -p /sundials-build
WORKDIR /sundials-build

RUN wget https://computation.llnl.gov/projects/sundials/download/sundials-4.0.1.tar.gz

RUN tar -xf sundials-4.0.1.tar.gz -C .

RUN ls -la
