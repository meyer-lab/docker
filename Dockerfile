FROM alpine:3.8
MAINTAINER Aaron S Meyer

RUN apk add --no-cache clang python3 valgrind ruby
