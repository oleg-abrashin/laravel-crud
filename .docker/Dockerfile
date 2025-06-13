FROM laravelsail/php83-composer

# Устанавливаем PostgreSQL расширение
RUN apt-get update && apt-get install -y \
    libpq-dev && docker-php-ext-install pdo_pgsql

# Устанавливаем Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

COPY .docker/php.ini /etc/php/8.3/cli/conf.d/99-custom.ini
