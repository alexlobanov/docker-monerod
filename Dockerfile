FROM centos:7
ENV MONERO_RELEASE v0.10.3.1

RUN yum -y update &&\
    yum -y install bzip2 &&\
    yum clean all
    
RUN useradd monerod

USER monerod
ENV HOME /home/monerod
WORKDIR /home/monerod

RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv 0x55432DF31CCD4FCD &&\
    curl -L -O https://getmonero.org/downloads/hashes.txt &&\
    gpg --verify hashes.txt && curl https://downloads.getmonero.org/cli/monero-linux-x64-$MONERO_RELEASE.tar.bz2 -O &&\
    grep "monero-linux-x64-$MONERO_RELEASE.tar.bz2" hashes.txt | sha256sum -c - &&\
    tar -xjvf monero-linux-x64-$MONERO_RELEASE.tar.bz2 &&\
    rm monero-linux-x64-$MONERO_RELEASE.tar.bz2 &&\
    cd ..

VOLUME /bitmonero

EXPOSE 18080 18081

ENTRYPOINT "./monero-$MONERO_RELEASE/monerod" "--config-file=/bitmonero/bitmonero.conf"
