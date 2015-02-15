#
# Dockerfile for Wallabag
#

FROM ubuntu:utopic

MAINTAINER Xavier Logerais <xavier@logerais.com>

ENV DEBIAN_FRONTEND noninteractive

# Installs add-apt-repository
RUN apt-get install -y software-properties-common

# Add hhvm repo
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
RUN add-apt-repository 'deb http://dl.hhvm.com/ubuntu utopic main'

# Update apt database
RUN apt-get update

# Install some utilities
RUN apt-get install -y curl wget unzip ca-certificates

# Install nginx
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install hhvm
RUN apt-get install -y hhvm

# Install Wallabag
RUN wget http://wllbg.org/latest -O /tmp/wallabag-latest.zip && unzip -d /var/www /tmp/wallabag-latest.zip && rm -rfv /tmp/wallabag-latest.zip && mv /var/www/wallabag-* /var/www/wallabag

# Install Composer
RUN cd /var/www/wallabag && curl -s http://getcomposer.org/installer | php && php composer.phar install

# Fix perms
RUN chown -R www-data /var/www/wallabag && chgrp -R www-data /var/www/wallabag

VOLUME /var/log/nginx

EXPOSE 80

WORKDIR /var/www
ENTRYPOINT ["nginx"]
