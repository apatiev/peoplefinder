FROM ubuntu:14.04

RUN apt-get update \
	&& apt-get install -y \
		build-essential \
		libxml2-dev \
    	libssl-dev \
    	m4 \
    	wget \
    && cd /tmp \
    && wget --no-check-certificate https://www.kannel.org/download/1.4.4/gateway-1.4.4.tar.gz \
    && wget http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb \
    && wget http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb \
	&& dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb \
    && dpkg -i bison_2.7.1.dfsg-1_amd64.deb \
    && tar zxf gateway-1.4.4.tar.gz \
    && cd gateway-1.4.4 \
    && ./configure --sysconfdir=/etc/kannel \
    && touch .depend \
    && make \
    && make check \
    && make install \
    && cd / \
    && rm -rf /tmp/* \
    && mkdir -p /var/log/kannel

COPY ./kannel.conf /etc/kannel/

EXPOSE 14000
EXPOSE 14001
EXPOSE 14002
