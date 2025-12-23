FROM php:8.4-apache

# Use the default development php.ini configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Setup bare-minimum extra extensions for Laravel & others
RUN DEBIAN_FRONTEND=noninteractive apt-get clean \
    && apt-get update \
	&& apt-get install -y --no-install-recommends --fix-missing \
		libmemcached-dev  \
		libfreetype6-dev \
		libxml2-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		zlib1g-dev \
		libzip-dev \
		libz-dev \
		libpq-dev  \
		libsqlite3-dev  \
		libicu-dev \
		g++ \
		git \
		zip \
		libmcrypt-dev \
		libvpx-dev \
		libjpeg-dev \
		libpng-dev \
		bzip2 \
		wget \
		libexpat1-dev \
		libbz2-dev \
		libgmp3-dev \
		libldap2-dev \
		unixodbc-dev \
		libsnmp-dev \
		libpcre2-dev \
		libtidy-dev \
		libaspell-dev \
		tar \
		less \
		nano \
		libcurl4-gnutls-dev \
		apt-utils \
		libxrender1 \
		unzip \
		libonig-dev \
		libldap2-dev \
		libxslt-dev \
		libwebp-dev \
		libkrb5-dev \
		libpspell-dev \
		librabbitmq-dev \
		librabbitmq4 \
        mariadb-client \
        openssh-client \
        libenchant-2-dev \
        libedit-dev \
        libsodium-dev

#RUN docker-php-ext-install -j$(nproc) bcmath
#RUN docker-php-ext-install -j$(nproc) bz2
#RUN docker-php-ext-install -j$(nproc) calendar
##RUN docker-php-ext-install -j$(nproc) ctype
##RUN docker-php-ext-install -j$(nproc) curl
#RUN docker-php-ext-install -j$(nproc) dba
#RUN docker-php-ext-install -j$(nproc) dl_test
##RUN docker-php-ext-install -j$(nproc) dom
#RUN docker-php-ext-install -j$(nproc) enchant
#RUN docker-php-ext-install -j$(nproc) exif
#RUN docker-php-ext-install -j$(nproc) ffi
##RUN docker-php-ext-install -j$(nproc) fileinfo
##RUN docker-php-ext-install -j$(nproc) filter
##RUN docker-php-ext-install -j$(nproc) ftp
#RUN docker-php-ext-install -j$(nproc) gd
#RUN docker-php-ext-install -j$(nproc) gettext
#RUN docker-php-ext-install -j$(nproc) gmp
##RUN docker-php-ext-install -j$(nproc) hash
##RUN docker-php-ext-install -j$(nproc) iconv
#RUN docker-php-ext-install -j$(nproc) intl
##RUN docker-php-ext-install -j$(nproc) json
#RUN docker-php-ext-install -j$(nproc) ldap
##RUN docker-php-ext-install -j$(nproc) mbstring
#RUN docker-php-ext-install -j$(nproc) mysqli
##RUN docker-php-ext-install -j$(nproc) odbc
#RUN docker-php-ext-install -j$(nproc) opcache
#RUN docker-php-ext-install -j$(nproc) pcntl
##RUN docker-php-ext-install -j$(nproc) pdo
##RUN docker-php-ext-install -j$(nproc) pdo_dblib
##RUN docker-php-ext-install -j$(nproc) pdo_firebird
#RUN docker-php-ext-install -j$(nproc) pdo_mysql
##RUN docker-php-ext-install -j$(nproc) pdo_odbc
#RUN docker-php-ext-install -j$(nproc) pdo_pgsql
##RUN docker-php-ext-install -j$(nproc) pdo_sqlite
#RUN docker-php-ext-install -j$(nproc) pgsql
##RUN docker-php-ext-install -j$(nproc) phar
##RUN docker-php-ext-install -j$(nproc) posix
##RUN docker-php-ext-install -j$(nproc) random
##RUN docker-php-ext-install -j$(nproc) readline
##RUN docker-php-ext-install -j$(nproc) reflection
##RUN docker-php-ext-install -j$(nproc) session
#RUN docker-php-ext-install -j$(nproc) shmop
##RUN docker-php-ext-install -j$(nproc) simplexml
#RUN docker-php-ext-install -j$(nproc) snmp
#RUN docker-php-ext-install -j$(nproc) soap
#RUN docker-php-ext-install -j$(nproc) sockets
##RUN docker-php-ext-install -j$(nproc) sodium
##RUN docker-php-ext-install -j$(nproc) spl
##RUN docker-php-ext-install -j$(nproc) standard
#RUN docker-php-ext-install -j$(nproc) sysvmsg
#RUN docker-php-ext-install -j$(nproc) sysvsem
#RUN docker-php-ext-install -j$(nproc) sysvshm
#RUN docker-php-ext-install -j$(nproc) tidy
##RUN docker-php-ext-install -j$(nproc) tokenizer
##RUN docker-php-ext-install -j$(nproc) xml
##RUN docker-php-ext-install -j$(nproc) xmlreader
##RUN docker-php-ext-install -j$(nproc) xmlwriter
#RUN docker-php-ext-install -j$(nproc) xsl
##RUN docker-php-ext-install -j$(nproc) zend_test
#RUN docker-php-ext-install -j$(nproc) zip

RUN phpModules=" \
                bcmath \
                bz2 \
                calendar \
                dba \
                dl_test \
                enchant \
                exif \
                ffi \
                gd \
                gettext \
                gmp \
                intl \
                ldap \
                mysqli \
                opcache \
                pcntl \
                pdo \
                pdo_mysql \
                pdo_pgsql \
                pgsql \
                shmop \
                snmp \
                soap \
                sockets \
                sysvmsg \
                sysvsem \
                sysvshm \
                tidy \
                xsl \
                zip \
            " \
	&& docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-configure pcntl --enable-pcntl \
	&& docker-php-ext-install -j$(nproc) $phpModules

RUN pecl channel-update pecl.php.net \
    && pecl install apcu \
	&& pecl install igbinary \
	&& pecl install memcached \
	&& pecl install mongodb \
	&& pecl install pcov \
	&& pecl install redis \
    && pecl install xdebug \
	&& docker-php-ext-enable apcu igbinary memcached mongodb pcov redis xdebug \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# https://stackoverflow.com/questions/9520914/installing-amqp-through-pecl
#RUN pecl install amqp-1.6.0 \
#	&& docker-php-ext-enable amqp \

# Create required custom directories
RUN mkdir -p $PHP_INI_DIR/conf.d/custom \
    && mkdir -p $PHP_INI_DIR/conf.d/from-host \
    && mkdir -p /var/www/src \
    && mkdir -p /etc/apache2/config-from-host \
    && mkdir -p /etc/apache2/shared-config-from-host

# Install composer and update path
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN mkdir -p /composer/cache && chmod -R 777 /composer
ENV PHP_INI_SCAN_DIR ":$PHP_INI_DIR/conf.d/custom:$PHP_INI_DIR/conf.d/from-host"
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
RUN chmod -R 777 /composer

# Set allowed plugins
RUN composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true

# Install code quality tools
RUN composer global require "squizlabs/php_codesniffer=*"
RUN composer global require "pheromone/phpcs-security-audit=*"
RUN composer global require "dealerdirect/phpcodesniffer-composer-installer=*"
RUN composer global require "friendsofphp/php-cs-fixer=*"
RUN composer global require "phpmd/phpmd=*"
RUN composer global require "phpstan/phpstan=*"
RUN composer global require "vimeo/psalm=*"
RUN composer global require "phpunit/phpunit=*"

## Sonar Scanner installation
#ENV PATH $PATH:/opt/sonar-scanner/bin
#ENV SONAR_SCANNER_VERSION "4.8.0.2856-linux"
#ENV SONAR_SCANNER_FILENAME "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip"
#ENV SONAR_SCANNER_DL_URL "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli"
#RUN rm -f /opt/${SONAR_SCANNER_FILENAME} \
#    && wget ${SONAR_SCANNER_DL_URL}/${SONAR_SCANNER_FILENAME} -O /opt/${SONAR_SCANNER_FILENAME} \
#    && unzip /opt/${SONAR_SCANNER_FILENAME} -d /opt \
#    && ln -s /opt/sonar-scanner-${SONAR_SCANNER_VERSION} /opt/sonar-scanner \
#    && touch /etc/profile.d/sonar-scanner.sh \
#    # Make available for login shells
#    && printf '%s\n' '#/bin/bash' 'export PATH="$PATH:/opt/sonar-scanner/bin"' > /etc/profile.d/sonar-scanner.sh

# Enable Apache mod_rewrite.
RUN a2enmod rewrite ssl headers proxy proxy_http

# Set global ServerName directive
RUN echo "" >> /etc/apache2/apache2.conf \
    && echo "# Global server name directive" >> /etc/apache2/apache2.conf \
    && echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

# Include optional Apache configuration from host.
RUN echo "" >> /etc/apache2/apache2.conf \
	&& echo "# Include the configurations from the host machine" >> /etc/apache2/apache2.conf \
	&& echo "IncludeOptional config-from-host/*.conf" >> /etc/apache2/apache2.conf \
	&& echo "IncludeOptional shared-config-from-host/*.conf" >> /etc/apache2/apache2.conf

# Leave Authorization header available
RUN echo "" >> /etc/apache2/apache2.conf \
    && echo "# Leave Authorization header available." >> /etc/apache2/apache2.conf \
    && echo "SetEnvIf Authorization \"(.*)\" HTTP_AUTHORIZATION=\$1" >> /etc/apache2/apache2.conf

# Set permissions for Apache user and group
#RUN chown -R www-data:www-data /var/www/html \
#	&& chown -R www-data:www-data /var/www/src

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Zagreb /etc/localtime

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && chown -R www-data:www-data /composer
