#!/bin/bash

set -exu

# Make Postifx databases
postmap /etc/postfix/sender_canonical
postmap /etc/postfix/main.cf

# Set directory permissions to non-privileged user
chown www-data:www-data /srv/tripplanner -R

# Start services
service cron start
service ntp start
service postfix start
service mongodb start
service php7.1-fpm start
service apache2 start
service supervisor start

# Run modified-tripplanner node.js
cd /srv/tripplanner/modeify
npm install
make install
make build-client
/srv/tripplanner/modeify/runmodeify.sh

# start the ssh daemon
/usr/sbin/sshd -D
