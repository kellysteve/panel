FROM php:8.2-cli

# Install required system packages
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip bcmath

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy app files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Cache config
RUN php artisan config:cache

# Expose Render's port
EXPOSE 10000

# Start Laravel using PHP built-in server
CMD php -S 0.0.0.0:10000 -t public
