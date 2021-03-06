FROM php:7.1-apache

# Use default php.ini (it is development version).
COPY php-config/php.ini /usr/local/etc/php/

# Setup bare-minimum extra extensions for Laravel & others
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
		libmemcached-dev  \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
		zlib1g-dev \
		libz-dev \
		libpq-dev  \
		libicu-dev \
		g++ \
		git \
		zip \
        libmcrypt-dev \
		bzip2 \
		wget \
		tar \
		less \
		nano \
		curl \
		libxrender1 \
		libldap2-dev \
		libxml2-dev \
		libgmp3-dev \
    && docker-php-ext-install -j$(nproc) bcmath mcrypt zip pdo pdo_mysql mysqli opcache soap gmp \
    && docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) intl \
	&& docker-php-ext-configure ldap \
		--with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) ldap \
	&& pecl install memcached \
	&& pecl install xdebug-2.9.2 \
	&& pecl install redis \
	&& docker-php-ext-enable memcached xdebug redis \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Install composer and update path
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
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

# Copy custom config to PHP config dir.
COPY php-config/custom.ini /usr/local/etc/php/conf.d/

# Enable Apache modules.
RUN a2enmod rewrite ssl headers proxy proxy_http

# Create required custom directories
RUN mkdir -p /var/www/src /etc/apache2/config-from-host

# Include optional Apache configuration from host.
RUN echo "" >> /etc/apache2/apache2.conf \
    && echo "# Include the configurations from the host machine" >> /etc/apache2/apache2.conf \
    && echo "IncludeOptional config-from-host/*.conf" >> /etc/apache2/apache2.conf

# Set permissions for Apache user and group
#RUN chown -R www-data:www-data /var/www/html \
#	&& chown -R www-data:www-data /var/www/src

# Change uid and gid of apache to docker user uid/gid 
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Zagreb /etc/localtime