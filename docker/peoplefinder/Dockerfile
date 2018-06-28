FROM ubuntu:14.04

ENV PF_USER=cloud
ENV PF_HOME_DIR=/home/$PF_USER/peoplefinder
ENV PF_CONF_DIR=/etc/peoplefinder
ENV PF_LOG_DIR=/var/log/peoplefinder

RUN adduser --disabled-password --gecos "" $PF_USER \
	&& usermod -a -G sudo,adm $PF_USER \
	&& apt-get update \
	&& apt-get -y install gcc \
	&& apt-get -y install python-dev \
	&& apt-get -y install python-pip \
	&& apt-get -y install libgeo-osm-tiles-perl \
	&& pip install uwsgi \
	&& mkdir -p $PF_CONF_DIR \
	&& mkdir -p $PF_LOG_DIR \
	&& mkdir -p /var/lib/osmocom/

COPY . $PF_HOME_DIR
COPY ./docker/peoplefinder/config.ini $PF_CONF_DIR/config.ini

RUN pip install -e $PF_HOME_DIR/web \
	&& PYTHONPATH="${PYTHONPATH}:$PF_HOME_DIR" initialize_peoplefinder_db $PF_CONF_DIR/config.ini  \
	&& chown -R $PF_USER:$PF_USER $PF_HOME_DIR \
	&& chown -R $PF_USER:$PF_USER $PF_CONF_DIR \
	&& chown -R $PF_USER:$PF_USER $PF_LOG_DIR \
	&& chown -R $PF_USER:$PF_USER /var/lib/osmocom/

EXPOSE 8080
WORKDIR $PF_HOME_DIR

USER $PF_USER

CMD ["uwsgi", "/etc/peoplefinder/config.ini"]
