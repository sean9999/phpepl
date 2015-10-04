FROM ubuntu:vivid
MAINTAINER Sean Macdonald <sean@crazyhorsecoding.com>

#   System
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

#   PHP7
RUN echo "deb http://repos.zend.com/zend-server/early-access/php7/repos ubuntu/" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --force-yes php7-nightly
RUN ln -s $PWD/php /usr/local/bin/php
ENV PATH "$PATH:/usr/local/php7/bin"
RUN echo "Path has been updated to $PATH"

#   Apache
RUN apt-get install -y apache2
RUN cp /usr/local/php7/libphp7.so /usr/lib/apache2/modules/ && cp /usr/local/php7/php7.load /etc/apache2/mods-available/
RUN echo "\n<FilesMatch \\.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>" >> /etc/apache2/apache2.conf
RUN a2dismod mpm_event && a2enmod mpm_prefork && a2enmod php7 && a2enmod rewrite
ADD vhost.php7.conf /etc/apache2/sites-available/php7.conf
RUN a2dissite 000-default && a2ensite php7

#   Back-end Codebase
RUN apt-get install -y curl
ADD repl.sh /repl.sh
RUN chmod 775 /*.sh
RUN mkdir -p /var/www/public
ADD code/ /var/www/public
WORKDIR /var/www/public
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && composer install

#   Front-end Codebase
RUN apt-get install -y nodejs npm git-all && ln -s $(which nodejs) /usr/local/bin/node
RUN npm install -g bower
RUN bower install --allow-root

EXPOSE 80
CMD ["/repl.sh"]
