FROM alpine:3.8
MAINTAINER Aaron S Meyer

USER root

RUN apk add --no-cache clang python3 valgrind ruby ghc

RUN wget https://computation.llnl.gov/projects/sundials/download/sundials-4.0.1.tar.gz

RUN tar -xf sundials-4.0.1.tar.gz
