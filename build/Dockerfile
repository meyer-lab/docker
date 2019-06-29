FROM jenkins/slave:alpine
MAINTAINER Aaron S Meyer

USER root

ENV PERSISTENT_DEPS build-base python3 valgrind git freetype openblas eigen eigen-dev bash python3-dev openssl make wget zlib perl shadow freetype fontconfig aspell aspell-en ruby gmp ghostscript curl openssh msttcorefonts-installer clang texlive biber texlive-xetex texmf-dist-science

RUN apk upgrade --update && \
    apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
    apk add --no-cache --virtual .build-deps cmake freetype-dev openblas-dev ghc cabal zlib-dev xz

# Jekyll things
RUN gem install bundler --no-document

RUN pip3 install --no-cache-dir --upgrade --prefer-binary pip virtualenv pandocfilters pandoc-mustache pylint

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
RUN make && make install

WORKDIR /

RUN rm -rf /sundials-build

# Build adept-2
RUN mkdir -p /adept-build
WORKDIR /adept-build

RUN wget http://www.met.reading.ac.uk/clouds/adept/adept-2.0.5.tar.gz && \
    tar -xf adept-2.0.5.tar.gz
WORKDIR /adept-build/adept-2.0.5
RUN ./configure "CXXFLAGS=-g -O3" && make && make install

WORKDIR /

RUN rm -rf /adept-build


RUN update-ms-fonts && fc-cache -f

USER jenkins

# Install Pandoc
RUN cabal update && cabal install pandoc pandoc-citeproc pandoc-crossref

# Remove build deps
USER root
RUN apk del .build-deps
RUN cp /home/jenkins/.cabal/bin/pandoc* /usr/bin/
RUN rm -rf /home/jenkins/.cabal/lib /home/jenkins/.cabal/packages /home/jenkins/.cabal/bin

RUN apk add --no-cache openblas-dev lapack lapack-dev

USER jenkins
