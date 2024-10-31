# Use the official PHP Apache image as the base image
FROM php:8.1-apache

# Set environment variables for phpBB version and document root
ENV VERSION_MAJOR=3
ENV VERSION_MINOR=3
ENV VERSION_PATCH=10
ENV VERSION_MAJOR_MINOR="${VERSION_MAJOR}.${VERSION_MINOR}"
ENV VERSION_FULL="${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}"
ENV DOCUMENT_ROOT=/var/www/html/phpbb

RUN echo "tilde.fans" > /etc/hostname

# Update php.ini settings to log all errors, including debug messages
RUN echo "log_errors=On" >> /usr/local/etc/php/php.ini && \
    echo "error_log=/dev/stderr" >> /usr/local/etc/php/php.ini && \
    echo "error_reporting=E_ALL" >> /usr/local/etc/php/php.ini && \
    echo "display_errors=On" >> /usr/local/etc/php/php.ini

RUN echo "sendmail_path = \"/usr/bin/msmtp -t\"" > /usr/local/etc/php/conf.d/sendmail.ini

RUN touch /var/log/msmtp.log
RUN chmod 666 /var/log/msmtp.log

# Install necessary packages for phpBB and Apache
RUN apt-get update && \
    apt-get install -y \
        wget \
        unzip \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libonig-dev \
        libmariadb-dev \
        msmtp \
        msmtp-mta \
        gettext-base && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd mysqli && \
    a2enmod rewrite

# Copy custom Apache configuration
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copy the msmtprc template
COPY msmtprc.tpl /etc/msmtprc.tpl

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

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default command to start Apache
CMD ["/entrypoint.sh"]
