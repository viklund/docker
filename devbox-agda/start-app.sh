#!/bin/sh

cd /srv/agda/agda
source ../env_settings_skel.txt
source /srv/agda-virtual-env/bin/activate
./manage.py syncdb
./manage.py runserver 0.0.0.0:8000
