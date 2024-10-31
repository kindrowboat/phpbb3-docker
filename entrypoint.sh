#!/usr/bin/env bash

envsubst < /etc/msmtprc.tpl > /etc/msmtprc
chmod 655 /etc/msmtprc

apache2-foreground
