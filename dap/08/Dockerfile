FROM php:8.5-apache

ARG XDEBUG=1

# Use the default development php.ini configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Setup bare-minimum extra extensions for Laravel & others
RUN DEBIAN_FRONTEND=noninteractive apt-get clean \
    && apt-get update \
	&& apt-get install -y --no-install-recommends --fix-missing \
		libmemcached-dev  \
		libfreetype6-dev \
		libxml2-dev \
		libjpeg-dev \
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

RUN phpModules=" \
                bcmath \
                bz2 \
                calendar \
                dba \
                enchant \
                exif \
                ffi \
                gd \
                gettext \
                gmp \
                intl \
                ldap \
                mysqli \
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

# Create required custom directories
RUN mkdir -p $PHP_INI_DIR/conf.d/custom \
    && mkdir -p $PHP_INI_DIR/conf.d/from-host \
    && mkdir -p /var/www/src \
    && mkdir -p /etc/apache2/config-from-host \
    && mkdir -p /etc/apache2/shared-config-from-host

# Install composer and update path
ENV COMPOSER_HOME=/composer
ENV PATH=$PATH:/composer/vendor/bin
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN mkdir -p /composer/cache && chmod 755 /composer
ENV PHP_INI_SCAN_DIR=":$PHP_INI_DIR/conf.d/custom:$PHP_INI_DIR/conf.d/from-host"
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
RUN chmod 755 /composer

# Set allowed plugins and install code quality tools
RUN composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true \
    && composer global require \
        squizlabs/php_codesniffer=* \
        pheromone/phpcs-security-audit=* \
        dealerdirect/phpcodesniffer-composer-installer=* \
        friendsofphp/php-cs-fixer=* \
        phpmd/phpmd=* \
        phpstan/phpstan=* \
        vimeo/psalm=* \
        phpunit/phpunit=*

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

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Zagreb /etc/localtime

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && chown -R www-data:www-data /composer

WORKDIR /var/www/html

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
