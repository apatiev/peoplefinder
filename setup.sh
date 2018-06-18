#!/bin/bash
set -e
set -x 

: ${PF_USER_NAME:=cloud}
: ${PF_HOME:=/home/$PF_USER_NAME}
: ${PF_SUPERVISOR_CONF_DIR:=/etc/supervisor/conf.d}
: ${PF_CONF_DIR:=/etc/peoplefinder}
: ${PF_LOG_DIR:=/var/log/peoplefinder}

echo Add new user "$PF_USER_NAME", please enter password below...
#adduser $PF_USER_NAME
adduser --disabled-password --gecos "" $PF_USER_NAME
usermod -a -G sudo,adm cloud

apt-get update

# install python-dev
apt-get -y install python-dev

# install nginx
apt-get -y install python-software-properties
apt-get -y install software-properties-common
#add-apt-repository 'deb http://download.opensuse.org/repositories/network:/osmocom:/latest/xUbuntu_16.04/'
add-apt-repository ppa:nginx/stable -y
apt-get update
apt-get -y install nginx
apt-get -y install kannel

# install pip & virtualenv
apt-get -y install python-pip
pip install virtualenv

# install supervisor
apt-get -y install supervisor
service supervisor restart

# install libgeo-osm-tiles-perl
apt-get -y install libgeo-osm-tiles-perl

# install gcc for install peoplefinder (psutil) and uwsgi
apt-get -y install gcc

# create env into home directory
sudo -H -u  $PF_USER_NAME bash -c 'virtualenv '$PF_HOME'/env'

# create directiories
mkdir -p $PF_CONF_DIR
mkdir -p $PF_LOG_DIR

# clone repository
sudo -H -u  $PF_USER_NAME bash -c 'cp -Rv ./ '$PF_HOME'/peoplefinder'

# install application
sudo -H -u  $PF_USER_NAME bash -c $PF_HOME'/env/bin/pip install -e '$PF_HOME'/peoplefinder/web'
sudo -H -u  $PF_USER_NAME bash -c $PF_HOME'/env/bin/pip install uwsgi'

cp -v "$PF_HOME/peoplefinder/web/development.example.ini" "$PF_CONF_DIR/config.ini"

# initialize db
PYTHONPATH="${PYTHONPATH}:$PF_HOME/peoplefinder" $PF_HOME/env/bin/initialize_peoplefinder_db "$PF_CONF_DIR/config.ini"
chown -v $PF_USER_NAME $PF_HOME/peoplefinder/storage/pf.sqlite

# configurate kannel
cp -Rv "$PF_HOME/peoplefinder/web/deploy/kannel" "/etc/default"
cp -Rv "$PF_HOME/peoplefinder/web/deploy/kannel.conf" "/etc/kannel"
/etc/init.d/kannel restart

# configure osmobsc
$PF_HOME/env/bin/python $PF_HOME/peoplefinder/web/peoplefinder/scripts/configure_osmobsc.py
sv restart osmo-trx osmo-bts osmo-nitb

# setup supervisor
cp -v "$PF_HOME/peoplefinder/web/deploy/peoplefinder.conf" "$SUPERVISOR_CONF_DIR"
cp -v "$PF_HOME/peoplefinder/web/deploy/comms_interface.conf" "$SUPERVISOR_CONF_DIR"
supervisorctl reread
supervisorctl update

# setup nginx
cp -v "$PF_HOME/peoplefinder/web/deploy/peoplefinder" "$NGINX_CONF_DIR/sites-available"
ln -vs "$NGINX_CONF_DIR/sites-available/peoplefinder" "$NGINX_CONF_DIR/sites-enabled"
rm -vf "$NGINX_CONF_DIR/sites-enabled/default"
service nginx restart
