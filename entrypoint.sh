#!/usr/bin/env bash

chown www-data:www-data -R /var/www/html/phpbb
envsubst < /etc/msmtprc.tpl > /etc/msmtprc
chmod 655 /etc/msmtprc

apache2-foreground
