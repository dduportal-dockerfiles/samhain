FROM centos:centos7
MAINTAINER Damien DUPORTAL <damien.duportal@gmail.com>

ENV SAMHAIN_VERSION 3.1.5

ADD http://www.la-samhna.de/samhain/s_rkey.html /tmp/key.html
ADD http://www.la-samhna.de/samhain/samhain-current.tar.gz /tmp/samhain.tgz

RUN yum install -y -q \
		bash \
		curl \
		gcc \
		gpg \
		make \
		openssl \
		tar \
	&& [ "$(md5sum /tmp/samhain.tgz | awk '{print $1}')" == "b72b526c6ee504317981e6dba1673b9d" ] \
	&& tar -x -z -f /tmp/samhain.tgz -C /tmp/ \
	&& gpg --import /tmp/key.html \
	&& [ $(gpg --fingerprint 0F571F6C | grep "EF6C EF54 701A 0AFD B86A  F4C3 1AAD 26C8 0F57 1F6C" | wc -l) -eq 1 ] \
	&& gpg --verify "/tmp/samhain-${SAMHAIN_VERSION}.tar.gz.asc" "/tmp/samhain-${SAMHAIN_VERSION}.tar.gz" \
	&& tar -x -z -f /tmp/samhain-${SAMHAIN_VERSION}.tar.gz -C /tmp/ \ 
	&& cd /tmp/samhain-${SAMHAIN_VERSION}; ./configure --enable-network=client; make; make install \
	&& yum erase -y glibc-devel kernel-headers \
	&& yum clean all \
	&& rm -rf /tmp/*

RUN samhain -t init
USER root

ENTRYPOINT ["/usr/local/sbin/samhain"]
CMD ["--help"]
