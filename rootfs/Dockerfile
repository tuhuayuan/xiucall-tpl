FROM index.tenxcloud.com/docker_library/php:5.6-apache
MAINTAINER Huayuan Tu <tuhuayuan@gmail.com>

ADD http://mirrors.163.com/.help/sources.list.jessie /etc/apt/sources.list

RUN cp /etc/apache2/mods-available/rewrite.* /etc/apache2/mods-enabled/
RUN cp /etc/apache2/mods-available/headers.* /etc/apache2/mods-enabled/

# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2-dev \
        && docker-php-ext-install iconv mcrypt zip mbstring soap \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install gd pdo_mysql mysql \
        && docker-php-ext-enable zip mbstring soap


COPY php.ini /usr/local/etc/php/
COPY repo/ /var/www/html/

RUN chown -hR www-data:www-data Runtime/ 

CMD ["apache2-foreground"]
