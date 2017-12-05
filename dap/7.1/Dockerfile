FROM php:7.1-apache-jessie

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
		git \
		zip \
        libmcrypt-dev \
		bzip2 \
		wget \
		tar \
		less \
		curl \
    && docker-php-ext-install -j$(nproc) bcmath mcrypt zip pdo pdo_mysql mysqli opcache \
    && docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
	&& pecl install memcached \
	&& pecl install xdebug \
	&& pecl install redis \
	&& docker-php-ext-enable memcached xdebug redis \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
	--install-dir=/usr/local/bin \
	--filename=composer

# Enable mod_rewrite.
RUN a2enmod rewrite

# Set app dir and owner
RUN chown -R www-data:www-data /var/www/html \
	&& mkdir -p /var/www/src \
	&& chown -R www-data:www-data /var/www/src