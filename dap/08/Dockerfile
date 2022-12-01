FROM --platform=linux/amd64 php:8-apache

# Use the default development php.ini configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Setup bare-minimum extra extensions for Laravel & others
RUN DEBIAN_FRONTEND=noninteractive apt-get clean \
    && apt-get update \
	&& apt-get install -y --no-install-recommends --fix-missing \
#	    apt-utils \
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
		libpcre3-dev \
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
		libc-client-dev \
		libkrb5-dev \
		libpspell-dev \
		librabbitmq-dev \
		librabbitmq4 \
        mariadb-client \
    && phpModules=" \
                bcmath \
                bz2 \
                calendar \
                exif \
                gd \
                gettext \
                gmp \
                imap \
                intl \
                ldap \
                mysqli \
                opcache \
                pcntl \
                pdo_mysql \
                pdo_pgsql \
                pgsql \
                pspell \
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
                pcntl \
            " \
	&& docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-configure pcntl --enable-pcntl \
	&& docker-php-ext-install -j$(nproc) $phpModules \
	&& pecl install xdebug-3.1.3 \
	&& pecl install memcached-3.1.5 \
	&& pecl install redis-5.3.7 \
	&& pecl install apcu-5.1.21 \
	&& pecl install igbinary-3.2.7 \
	&& pecl install mongodb-1.12.1 \
	&& pecl install pcov-1.0.11 \
	&& docker-php-ext-enable xdebug memcached redis apcu igbinary mongodb pcov \
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
ENV PHP_INI_SCAN_DIR ":$PHP_INI_DIR/conf.d/custom:$PHP_INI_DIR/conf.d/from-host"
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Set allowed plugins
RUN composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true

# Install code quality tools
RUN composer global require "squizlabs/php_codesniffer=*"
RUN composer global require "pheromone/phpcs-security-audit=*"
RUN composer global require "phpcompatibility/php-compatibility=*"
RUN composer global require "dealerdirect/phpcodesniffer-composer-installer=*"
RUN composer global require "friendsofphp/php-cs-fixer=*"
RUN composer global require "phpmd/phpmd=*"
RUN composer global require "phpstan/phpstan=*"
RUN composer global require "vimeo/psalm=*"
RUN composer global require "phpunit/phpunit=*"

# Local PHP Security Checker
# https://github.com/fabpot/local-php-security-checker/releases/download/v1.2.0/local-php-security-checker_1.2.0_linux_amd64
ENV PATH $PATH:/opt/local-php-security-checker
RUN rm -f /opt/local-php-security-checker/* \
    && mkdir -p /opt/local-php-security-checker \
    && wget https://github.com/fabpot/local-php-security-checker/releases/download/v1.2.0/local-php-security-checker_1.2.0_linux_amd64 -O /opt/local-php-security-checker/local-php-security-checker \
    && chmod a+x /opt/local-php-security-checker/local-php-security-checker \
    && touch /etc/profile.d/local-php-security-checker.sh \
    # Make available for login shells
    && printf '%s\n' '#/bin/bash' 'export PATH="$PATH:/opt/local-php-security-checker"' > /etc/profile.d/local-php-security-checker.sh

# Sonar Scanner installation
ENV PATH $PATH:/opt/sonar-scanner/bin
ENV SONAR_SCANNER_VERSION "4.7.0.2747-linux"
ENV SONAR_SCANNER_FILENAME "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip"
ENV SONAR_SCANNER_DL_URL "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli"
RUN rm -f /opt/${SONAR_SCANNER_FILENAME} \
    && wget ${SONAR_SCANNER_DL_URL}/${SONAR_SCANNER_FILENAME} -O /opt/${SONAR_SCANNER_FILENAME} \
    && unzip /opt/${SONAR_SCANNER_FILENAME} -d /opt \
    && ln -s /opt/sonar-scanner-${SONAR_SCANNER_VERSION} /opt/sonar-scanner \
    && touch /etc/profile.d/sonar-scanner.sh \
    # Make available for login shells
    && printf '%s\n' '#/bin/bash' 'export PATH="$PATH:/opt/sonar-scanner/bin"' > /etc/profile.d/sonar-scanner.sh

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

# Set permissions for Apache user and group
#RUN chown -R www-data:www-data /var/www/html \
#	&& chown -R www-data:www-data /var/www/src

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Zagreb /etc/localtime

# Copy some required files to container
COPY shared/scripts /var/scripts
RUN chmod a+x /var/scripts/*
# Copy custom config to PHP config dir.
COPY 08/php-config/custom.ini "$PHP_INI_DIR/conf.d/custom"

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

CMD /var/scripts/run.sh