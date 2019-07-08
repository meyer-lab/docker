FROM jenkins/slave:alpine
MAINTAINER Aaron S Meyer

USER root

# Prevent us constantly downloading these
RUN apk upgrade --update && apk add wget && \
    wget https://computation.llnl.gov/projects/sundials/download/sundials-4.1.0.tar.gz && \
    tar -xf sundials-4.1.0.tar.gz && \
    wget http://www.met.reading.ac.uk/clouds/adept/adept-2.0.5.tar.gz && \
    tar -xf adept-2.0.5.tar.gz

ENV PERSISTENT_DEPS build-base python3 valgrind git freetype openblas eigen eigen-dev bash openssl make zlib perl shadow freetype fontconfig aspell aspell-en ruby gmp ghostscript curl openssh msttcorefonts-installer clang texlive biber texlive-xetex texmf-dist-science freetype-dev openblas-dev python3-dev xz cppunit-dev cppunit g++ gfortran file binutils musl-dev cython libstdc++ librsvg ttf-opensans ttf-dejavu texmf-dist-latexextra texmf-dist-bibtexextra libxslt-dev libxml2-dev
ENV BUILD_DEPS cmake zlib-dev

RUN apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS

# Jekyll, python3 and font things
RUN gem install bundler --no-document && \
    update-ms-fonts && fc-cache -f && \
    pip3 install --no-cache-dir --upgrade pip pandocfilters pandoc-mustache setuptools virtualenv numpy

# Build sundials
WORKDIR /home/jenkins/sundials-4.1.0
RUN mkdir -p build
WORKDIR /home/jenkins/sundials-4.1.0/build
RUN cmake .. -DBUILD_SHARED_LIBS=ON \
	-DBUILD_ARKODE=OFF -DBUILD_IDAS=OFF -DBUILD_KINSOL=OFF -DBUILD_IDA=OFF \
	-DCMAKE_C_FLAGS="-O3" -DEXAMPLES_ENABLE_C=OFF
RUN make && make install

# Build adept-2
WORKDIR /home/jenkins/adept-2.0.5
RUN ./configure "CXXFLAGS=-g -O3" && make && make install

WORKDIR /
RUN rm -rf /home/jenkins/adept* /home/jenkins/sundials*
RUN apk del .build-deps

# Install Pandoc
RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.4.1/linux-pandoc_2_7_2.tar.gz && \
    wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-linux.tar.gz && \
    tar -C /usr/bin -xf linux-pandoc_2_7_2.tar.gz && \
    tar -C /usr --strip 1 -xf pandoc-2.7.2-linux.tar.gz && \
    rm /*.tar.gz

RUN apk add hdf5-dev --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

USER jenkins
WORKDIR /home/jenkins/

RUN pip3 install --user Cython
RUN pip3 install --user scipy
RUN pip3 install --user pandas
RUN pip3 install --user matplotlib
RUN pip3 install --user seaborn
RUN pip3 install --user scikit-learn
