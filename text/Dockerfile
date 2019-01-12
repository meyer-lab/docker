FROM alpine:3.8
MAINTAINER Aaron S Meyer

USER root

ENV PERSISTENT_DEPS python3 make git wget zlib perl shadow freetype fontconfig bash aspell aspell-en ruby
ENV BUILD_DEPS build-base ghc cabal zlib-dev

RUN apk upgrade --update && \
    apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS

# Jekyll things
RUN gem install bundler

# Install Pandoc
RUN cabal update && \
	cabal install pandoc pandoc-citeproc pandoc-crossref
	
RUN cp /root/.cabal/bin/* /usr/bin/

RUN pip3 install --no-cache-dir --upgrade pip && \
	pip3 install --no-cache-dir pandocfilters pandoc-mustache

RUN apk del .build-deps && \
	rm -Rf /root/.cabal /root/.ghc

RUN adduser -D jenkins
USER jenkins

# Install tinytex
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh

USER root
