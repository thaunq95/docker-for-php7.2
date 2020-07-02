FROM php:7.2-fpm

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# install git
RUN apt-get update && \
        apt-get install -y --no-install-recommends git

#install some base extensions
RUN apt-get install -y \
        zlib1g-dev \
        libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libicu-dev \
        libpq-dev \
        libxpm-dev \
        libvpx-dev \        
        libxml2-dev
        build-essential \
        nodejs \
        && pecl install mcrypt && docker-php-ext-enable mcrypt \
        && docker-php-ext-install -j$(nproc) iconv pdo_mysql intl opcache mbstring curl zip \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd \
        && apt-get autoremove \
        && apt-get clean


# Install Imagick
RUN apt-get update && apt-get install -y \
    libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Install Composer

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

CMD ["php-fpm"]
