FROM php:8.0-fpm

USER root

RUN docker-php-ext-install pdo pdo_mysql


RUN apt-get update && apt-get install -y sudo


# Install useful tools
RUN apt-get -y install apt-utils nano wget dialog vim

# Install important libraries
RUN echo "\e[1;33mInstall important libraries\e[0m"
RUN apt-get -y install --fix-missing \
    apt-utils \
    build-essential \
    git \
    curl \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    libbz2-dev \
    locales \
    libmcrypt-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev
    
RUN echo "\e[1;33mInstall important docker dependencies\e[0m"
RUN docker-php-ext-install \
    exif \
    pcntl \
    bcmath \
    ctype \
    curl \
    iconv \
    xml \
    soap \
    pcntl \
    mbstring \
    tokenizer \
    bz2 \
    zip \
    intl

# Install Composer
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

COPY ./src .

RUN composer update --no-interaction --no-dev --optimize-autoloader

RUN composer install --no-interaction --no-dev --optimize-autoloader


RUN chown -R www-data:www-data /var/www
RUN chmod -R 775 /var/www
RUN chmod -R 775 /var/www/bootstrap/cache
RUN chmod -R 777 /var/www/storage/logs

RUN chmod +x ./start.sh

# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql