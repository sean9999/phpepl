FROM ubuntu:trusty
MAINTAINER Sean Macdonald <sean@crazyhorsecoding.com>

#   System
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

#   PHP7
RUN apt-get install -y wget
ENV PATH /usr/local/php7/bin:$PATH
ENV PHP7_DEB_ARCHIVE http://repos.zend.com/zend-server/early-access/php7/php-7.0-latest-DEB-x86_64.tar.gz
RUN wget -P /tmp $PHP7_DEB_ARCHIVE && tar xzPf /tmp/php-7*.tar.gz

#   Apache
RUN apt-get install -y \
    apache2 \
    libcurl4-openssl-dev \
    libmcrypt-dev \
    libxml2-dev libjpeg-dev \
    libjpeg62 \
    libfreetype6-dev \
    libmysqlclient-dev \
    libt1-dev \
    libgmp-dev \
    libpspell-dev \
    libicu-dev \
    librecode-dev
ADD vhost.php7.conf /etc/apache2/sites-available/php7.conf
RUN cp /usr/local/php7/libphp7.so /usr/lib/apache2/modules/
RUN cp /usr/local/php7/php7.load /etc/apache2/mods-available/
RUN echo "\n<FilesMatch \\.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>" >> /etc/apache2/apache2.conf
RUN a2dismod mpm_event && a2enmod mpm_prefork && a2enmod php7 && a2enmod rewrite
RUN a2dissite 000-default && a2ensite php7

#   REPL
RUN apt-get install -y curl
ADD repl.sh /repl.sh
RUN chmod 775 /*.sh
RUN mkdir -p /var/www/public
ADD code/ /var/www/public
WORKDIR /var/www/public
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer install

#   Bower
RUN apt-get install -y nodejs npm git-all \
    && ln -s $(which nodejs) /usr/local/bin/node
RUN npm install -g bower
RUN bower install --allow-root

EXPOSE 80
CMD ["/repl.sh"]
