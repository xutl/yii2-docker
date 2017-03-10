FROM php:7.1.2-fpm-alpine

RUN apk add --no-cache --virtual .build-deps \
            libicu-dev \
            libjpeg-dev \
            libjpeg62-turbo-dev \
            libpng12-dev \
            libfreetype6-dev \
        --no-install-recommends \

    # Required extension
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) mbstring \

    # Additional common extensions
    && docker-php-ext-install -j$(nproc) opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install apcu-5.1.8 && docker-php-ext-enable apcu \

    # Required by composer
    && docker-php-ext-install -j$(nproc) zip \

    # Cleanup to keep the images size small
    && apk del .build-deps

# Required by composer
RUN apk add --no-cache \
            git \
            zlib1g-dev \
# Install composer
COPY install-composer /install-composer
RUN /install-composer && rm /install-composer
