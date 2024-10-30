# Use the official PHP Apache image as the base image
FROM php:8.1-apache

# Set environment variables for phpBB version and document root
ENV VERSION_MAJOR=3
ENV VERSION_MINOR=3
ENV VERSION_PATCH=10
ENV VERSION_MAJOR_MINOR="${VERSION_MAJOR}.${VERSION_MINOR}"
ENV VERSION_FULL="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"
ENV DOCUMENT_ROOT=/var/www/html/phpbb

# Install necessary packages for phpBB and Apache
RUN apt-get update && \
    apt-get install -y \
        wget \
        unzip \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libonig-dev \
        libmariadb-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd mysqli && \
    a2enmod rewrite

# Download and install phpBB
#RUN wget -q -O /tmp/phpBB.zip https://www.phpbb.com/files/release/phpBB-$PHPBB_VERSION.zip && \
RUN wget -q -O /tmp/phpBB.zip https://download.phpbb.com/pub/release/$VERSION_MAJOR_MINOR/$VERSION_FULL/phpBB-$VERSION_FULL.zip && \
    unzip /tmp/phpBB.zip -d /tmp/ && \
    mv /tmp/phpBB3 $DOCUMENT_ROOT && \
    rm /tmp/phpBB.zip && \
    chown -R www-data:www-data $DOCUMENT_ROOT && \
    chmod -R 755 $DOCUMENT_ROOT

# Copy custom Apache configuration
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# # Set Apache document root
# ENV APACHE_DOCUMENT_ROOT=$DOCUMENT_ROOT
# RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Expose port 80 for web traffic
EXPOSE 80

# Copy custom php.ini configuration (optional)
# COPY php.ini /usr/local/etc/php/

# Set working directory
WORKDIR $DOCUMENT_ROOT

# Add healthcheck to verify server availability
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl --fail http://localhost || exit 1

# Default command to start Apache
CMD ["apache2-foreground"]
