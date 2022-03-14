FROM php:7.4-apache

# Use the default development php.ini configuration
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Setup bare-minimum extra extensions for Laravel & others
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get install -y \
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
		mariadb-client \
	&& docker-php-ext-install -j$(nproc) bcmath zip pdo pdo_mysql mysqli opcache mbstring curl json xml bz2 soap gmp \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) intl \
	&& docker-php-ext-configure ldap \
		--with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) ldap \
	&& pecl install xdebug-2.9.2 \
	&& pecl install memcached-3.1.4 \
	&& pecl install redis-5.1.1 \
	&& docker-php-ext-enable xdebug memcached redis \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install composer and update path
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Install code quality tools
RUN composer global require "squizlabs/php_codesniffer=*"
RUN composer global require "pheromone/phpcs-security-audit=*"
RUN composer global require "phpcompatibility/php-compatibility=*"
RUN composer global require "dealerdirect/phpcodesniffer-composer-installer=*"
RUN composer global require "friendsofphp/php-cs-fixer=*"
RUN composer global require "phpmd/phpmd=*"
RUN composer global require "phpstan/phpstan=*"
RUN composer global require "vimeo/psalm=*"
RUN composer global require "sensiolabs/security-checker=*"
RUN composer global require "phpunit/phpunit=*"

# Sonar Scanner installation
ENV PATH $PATH:/opt/sonar-scanner/bin
ENV SONAR_SCANNER_VERSION "4.6.0.2311-linux"
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

# Create required custom directories
RUN mkdir -p /var/www/src /etc/apache2/config-from-host /etc/apache2/shared-config-from-host

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
COPY 74/php-config/custom.ini "$PHP_INI_DIR/conf.d/"

# Change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

CMD /var/scripts/run.sh