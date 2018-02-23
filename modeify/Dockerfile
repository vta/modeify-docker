FROM ubuntu:16.04

ENV TERM xterm

ENV DEBIAN_FRONTEND=noninteractive

# Set locale to en-US.UTF
RUN export LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8

# Fun apt and install basics
RUN apt-get update --fix-missing
RUN apt-get install -y openssh-server build-essential git curl python-pip time ntp supervisor inotify-tools telnet net-tools vim rsync logrotate && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir /var/run/sshd

# Install Apache with modules then clear apt source.lists
RUN apt-get update && apt-get install -y software-properties-common apt-utils python-software-properties language-pack-en-base && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && apt-get install -y apache2-suexec-pristine libapache2-mod-fcgid libapache2-mod-security2 libapache2-mod-geoip apache2 apache2-bin apache2-data apache2-utils apache2-dev && apt-get clean && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add certs
# @todo - make this private and remove from cached git repo
#ADD ssl/AddTrustExternalCARoot.crt /etc/apache2/ssl/AddTrustExternalCARoot.crt
#ADD ssl/chained_star.vta.org.crt /etc/apache2/ssl/chained_star.vta.org.crt
#ADD ssl/key.pem /etc/apache2/ssl/key.pem
#ADD ssl/NetworkSolutions_CA.crt /etc/apache2/ssl/NetworkSolutions_CA.crt
#ADD ssl/server.key /etc/apache2/ssl/server.key
#ADD ssl/STAR.VTA.ORG.crt /etc/apache2/ssl/STAR.VTA.ORG.crt
#ADD ssl/UTNAddTrustServer_CA.crt /etc/apache2/ssl/UTNAddTrustServer_CA.crt
ADD ssl /etc/apache2/ssl
RUN chmod 0600 /etc/apache2/ssl/*

# Enable and Disable desired site confs
RUN a2dissite default-ssl
ADD sites-available/modeify.conf /etc/apache2/sites-available/modeify.conf
RUN a2ensite modeify
RUN rm /etc/apache2/sites-available/000-default.conf
ADD sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf

# Install NodeJS latest
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
RUN /bin/bash nodesource_setup.sh
RUN apt-get update
RUN apt-get install -y nodejs mongodb

# Install modeify from tagged release
RUN mkdir /srv/tripplanner/
RUN git clone https://github.com/vta/modeify.git /srv/tripplanner/modeify
RUN cd /srv/tripplanner/modeify && git checkout -b deployment tags/2.2
RUN mkdir /srv/tripplanner/modeify/deployment
ADD config /srv/tripplanner/modeify/config
ADD deployment /srv/tripplanner/modeify/deployment
ADD restart-modeify.sh /srv/tripplanner/modeify/runmodeify.sh
RUN chmod 0770 /srv/tripplanner/modeify/runmodeify.sh

# Add robots.txt
ADD robots.txt /srv/tripplanner/modeify/assets/robots.txt

# Install PHP 7.1 Official
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-mark hold php7.2*
RUN apt-get install -y php-geoip imagemagick php-imagick php-mongodb php-ssh2 php-uuid php-yaml php7.1-cgi php7.1-cli php7.1-dev php7.1-fpm php7.1-bcmath php7.1-bz2 php7.1-common php7.1-curl php7.1-gd php7.1-intl php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-readline php7.1-recode php7.1-xml php7.1-xmlrpc php7.1-zip php7.1-opcache php7.1 php7.1-xsl

# Enable Apache modules after PHP-FPM is installed
RUN a2dismod mpm_event mpm_worker
RUN a2enmod mpm_prefork proxy_fcgi proxy_http vhost_alias proxy proxy_http alias rewrite suexec ssl setenvif headers
RUN a2enconf php7.1-fpm


# Configure mail server for notify email share feature
RUN apt-get update
RUN apt-get -y install postfix
ADD postfix/mailname /etc/mailname
ADD postfix/main.cf /etc/postfix/main.cf
ADD postfix/sasl_passwd /etc/postfix/sasl_passwd
ADD postfix/sender_canonical /etc/postfix/sender_canonical
RUN chmod 0600 /etc/postfix/sasl_passwd
RUN pear install Mail_Mime Mail

ADD supervisor /etc/supervisor

# Expose ports within container
EXPOSE 22 5000

ADD docker-startup.sh /
CMD ["/docker-startup.sh"]