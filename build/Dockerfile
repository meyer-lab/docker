FROM jenkins/slave:latest
MAINTAINER Aaron S Meyer

USER root

# Prevent us constantly downloading these
RUN apt update && \
    apt install -y wget && \
    wget https://computation.llnl.gov/projects/sundials/download/sundials-4.1.0.tar.gz && \
    tar -xf sundials-4.1.0.tar.gz && \
    wget http://www.met.reading.ac.uk/clouds/adept/adept-2.0.5.tar.gz && \
    tar -xf adept-2.0.5.tar.gz && \
    wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt upgrade -y && \
    apt install -y python3 python3-dev git make texlive-base texlive-science texlive-fonts-recommended texlive-latex-recommended texlive-generic-recommended texlive-lang-english texlive-lang-greek biber texlive-xetex clang valgrind libfreetype6 libblas-dev libopenblas-dev libeigen3-dev fontconfig aspell aspell-en ruby libgmp10 ghostscript libfreetype6-dev liblapack-dev cmake xz-utils zlib1g-dev python3-pip xfonts-utils cabextract libcppunit-dev && \
    gem install bundler --no-document && \
    pip3 install --no-cache-dir --upgrade pip virtualenv pandocfilters pandoc-mustache pylint

RUN dpkg -i ttf-mscorefonts-installer_3.6_all.deb && \
    rm ttf-mscorefonts-installer_3.6_all.deb && \
    fc-cache -f

# Build sundials
WORKDIR /home/jenkins/sundials-4.1.0
RUN mkdir -p build
WORKDIR /home/jenkins/sundials-4.1.0/build
RUN cmake .. -DBUILD_SHARED_LIBS=ON \
	-DBUILD_ARKODE=OFF -DBUILD_IDAS=OFF -DBUILD_KINSOL=OFF -DBUILD_IDA=OFF \
	-DCMAKE_C_FLAGS="-O3" -DEXAMPLES_ENABLE_C=OFF
RUN make && make install

WORKDIR /

RUN rm -rf /home/jenkins/sundials*

# Build adept-2
WORKDIR /home/jenkins/adept-2.0.5
RUN ./configure "CXXFLAGS=-g -O3" && make && make install

WORKDIR /

RUN rm -rf /home/jenkins/adept*

# Install Pandoc
RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.4.1/linux-pandoc_2_7_2.tar.gz
RUN wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-linux.tar.gz
RUN tar -C /usr/bin -xf linux-pandoc_2_7_2.tar.gz
RUN tar -C /usr --strip 1 -xf pandoc-2.7.2-linux.tar.gz
RUN rm /*.tar.gz

# Remove cruft
RUN rm -r /usr/share/doc
RUN apt purge -y cabextract cmake && apt autoremove -y

USER jenkins
WORKDIR /home/jenkins/
