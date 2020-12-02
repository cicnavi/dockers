FROM php:5.6-apache-jessie

# Use default php.ini (it is development version).
COPY php-config/php.ini /usr/local/etc/php/

# Setup bare-minimum extra extensions for Laravel & others
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
		zlib1g-dev \
		libz-dev \
		libpq-dev \
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
		libfontconfig1 \
		libxrender1 \
		libgmp-dev \
		re2c \
		libmhash-dev \
		file \
    && docker-php-ext-install -j$(nproc) bcmath mcrypt zip pdo pdo_mysql mysqli \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
	&& docker-php-ext-configure gmp \
	&& docker-php-ext-install -j$(nproc) gmp \
    && docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) intl \
	&& pecl install xdebug-2.5.5 \
	&& pecl install redis-3.1.0 \
	&& docker-php-ext-enable xdebug redis \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# Install composer and update path
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Install code quality tools
RUN composer global require "squizlabs/php_codesniffer=*"

# Enable apache modules.
RUN a2enmod rewrite ssl headers

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