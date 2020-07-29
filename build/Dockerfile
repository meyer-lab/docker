FROM jenkins/slave:latest-jdk11
MAINTAINER Aaron S Meyer

USER root

# Prevent us constantly downloading these
RUN wget --quiet https://computing.llnl.gov/projects/sundials/download/sundials-5.2.0.tar.gz && \
    tar -xf sundials-5.2.0.tar.gz && \
    wget --quiet http://www.met.reading.ac.uk/clouds/adept/adept-2.0.5.tar.gz && \
    tar -xf adept-2.0.5.tar.gz

RUN sed -i 's/main/main contrib/g' /etc/apt/sources.list
RUN sed -i 's/buster/bullseye/g' /etc/apt/sources.list
RUN sed -i '/security/d' /etc/apt/sources.list

RUN apt-get update && apt -y --no-install-recommends full-upgrade && apt -y autoremove

RUN apt-get install -y --no-install-recommends git-lfs python3 python3-pip python3-dev git bash openssl make fontconfig aspell aspell-en ruby ghostscript curl graphviz libfreetype6-dev pkg-config fonts-dejavu libxslt-dev libxml2-dev libhdf5-dev libzmq3-dev ruby-dev python3-setuptools cmake g++ gcc libopenblas-dev libeigen3-dev gfortran librsvg2-bin libcppunit-dev libqt5widgets5 libatomic1 libblas-dev liblapack-dev libatlas-base-dev

RUN apt-get install -y texlive-full

RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get install -y ttf-mscorefonts-installer && fc-cache

# Jekyll, python3 and font things
RUN gem install bundler --no-document && \
    pip3 install --no-cache-dir --upgrade pip pandocfilters pandoc-mustache virtualenv

# Build sundials
WORKDIR /home/jenkins/sundials-5.2.0
RUN mkdir -p build
WORKDIR /home/jenkins/sundials-5.2.0/build
RUN cmake .. -DBUILD_SHARED_LIBS=ON \
	-DBUILD_ARKODE=OFF -DBUILD_IDAS=OFF -DBUILD_KINSOL=OFF -DBUILD_IDA=OFF \
	-DCMAKE_C_FLAGS="-Ofast" -DEXAMPLES_ENABLE_C=OFF \
	-DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib
RUN make && make install

# Build adept-2
WORKDIR /home/jenkins/adept-2.0.5
RUN ./configure "CXXFLAGS=-g -Ofast" && make && make install

WORKDIR /
RUN rm -rf /home/jenkins/adept* /home/jenkins/sundials*

# Install Pandoc
RUN wget --quiet https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.6.2a/pandoc-crossref-Linux-2.9.2.1.tar.xz && \
    wget --quiet https://github.com/jgm/pandoc/releases/download/2.9.2.1/pandoc-2.9.2.1-linux-amd64.tar.gz && \
    tar -C /usr/bin -xf pandoc-crossref-Linux-2.9.2.1.tar.xz && \
    tar -C /usr --strip 1 -xf pandoc-2.9.2.1-linux-amd64.tar.gz && \
    rm /*.tar.gz

# Install julia
RUN wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.0-rc2-linux-x86_64.tar.gz && \
    tar -C /usr/ --strip 1 -xf julia-1.5.0-rc2-linux-x86_64.tar.gz && \
    rm /*.tar.gz

RUN ldconfig

USER jenkins
WORKDIR /home/jenkins/
