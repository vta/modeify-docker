#!/bin/bash

set -exu
# Start services
service cron start
service ntp start
service postfix start
service mongodb start
service php7.1-fpm start
service apache2 start
service supervisor start

# Run modified-tripplanner node.js
/srv/tripplanner/modeify/runmodeify.sh

# start the ssh daemon
/usr/sbin/sshd -D
