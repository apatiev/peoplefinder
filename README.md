# PeopleFinder
OpenBSC-based web application for UmSite GSM to locate people.

Components:

* UmSite GSM basestation + additional hardware
* Telephony backend software
* PeopleFinder backend software
* PeopleFinder frontend

Features:

* Lists registered phones
* Tracking selected phone and show it's location on the map (using timing advance)
* SMS communication
* Configurable parameters

Demo: http://194.165.0.105:8888

Developed by NextGIS, Telstra and Fairwaves.

How to run the application on a ubuntu 14.04
-------------
* Clone the repo

* Make the script executable:
chmod +x peoplefinder/web/deploy/ubuntu_14_04_install_deps.sh

* run the script (not being a root user!):
./peoplefinder/web/deploy/ubuntu_14_04_install_deps.sh

* Change user to 'cloud':
su cloud

* Run the uwsgi server:
/home/cloud/env/bin/uwsgi /etc/peoplefinder/config.ini

* Open your server ip in a browser

License information:
-------------
This program is licensed under GNU GPL v2 or any later version

Commercial support
----------
Need to fix a bug or add a feature to PeopleFinder? We provide custom development and support for this software. [Contact us](http://nextgis.ru/en/contact/) to discuss options!

[![http://nextgis.com](http://nextgis.ru/img/nextgis.png)](http://nextgis.com)
