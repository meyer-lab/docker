FROM jenkins/slave:latest-jdk11
MAINTAINER Aaron S Meyer

USER root

# Prevent us constantly downloading these
RUN wget --quiet https://computation.llnl.gov/projects/sundials/download/sundials-5.0.0.tar.gz && \
    tar -xf sundials-4.1.0.tar.gz && \
    wget --quiet http://www.met.reading.ac.uk/clouds/adept/adept-2.0.5.tar.gz && \
    tar -xf adept-2.0.5.tar.gz

RUN sed -i 's/stretch/buster/g' /etc/apt/sources.list

RUN apt-get update && apt -y --no-install-recommends full-upgrade && apt -y autoremove

RUN apt-get install -y --no-install-recommends git-lfs python3 python3-pip python3-dev git bash openssl make fontconfig aspell aspell-en ruby ghostscript curl graphviz libfreetype6-dev pkg-config ttf-dejavu libxslt-dev libxml2-dev libhdf5-dev libzmq3-dev ruby-dev python3-setuptools cmake g++ gcc libopenblas-dev libeigen3-dev gfortran librsvg2-bin libcppunit-dev

# Jekyll, python3 and font things
RUN gem install bundler --no-document && \
    pip3 install --no-cache-dir --upgrade pip pandocfilters pandoc-mustache virtualenv

# Build sundials
WORKDIR /home/jenkins/sundials-5.0.0
RUN mkdir -p build
WORKDIR /home/jenkins/sundials-5.0.0/build
RUN cmake .. -DBUILD_SHARED_LIBS=ON \
	-DBUILD_ARKODE=OFF -DBUILD_IDAS=OFF -DBUILD_KINSOL=OFF -DBUILD_IDA=OFF \
	-DCMAKE_C_FLAGS="-O3" -DEXAMPLES_ENABLE_C=OFF \
	-DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib
RUN make && make install

# Build adept-2
WORKDIR /home/jenkins/adept-2.0.5
RUN ./configure "CXXFLAGS=-g -O3" && make && make install

WORKDIR /
RUN rm -rf /home/jenkins/adept* /home/jenkins/sundials*

# Install Pandoc
RUN wget --quiet https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.4.1a/linux-pandoc_2_7_3.tar.gz && \
    wget --quiet https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-linux.tar.gz && \
    tar -C /usr/bin -xf linux-pandoc_2_7_3.tar.gz && \
    tar -C /usr --strip 1 -xf pandoc-2.7.3-linux.tar.gz && \
    rm /*.tar.gz

# Install julia
RUN wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/1.2/julia-1.2.0-linux-x86_64.tar.gz && \
    tar -C /usr/ --strip 1 -xf julia-1.2.0-linux-x86_64.tar.gz && \
    rm /*.tar.gz

RUN ldconfig

USER jenkins
WORKDIR /home/jenkins/

RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh
ENV PATH="/home/jenkins/.TinyTeX/bin/x86_64-linux:${PATH}"

RUN tlmgr install biblatex biber wrapfig titlesec biblatex-science biblatex-nature mathtools utopia logreq microtype setspace lineno preprint type1cm
