# Set defaults.
defaults
auth           on
tls            ${MSMTP_TLS}
tls_trust_file ${MSMTP_TLS_TRUST_FILE}
logfile        /var/log/msmtp.log

# Set account migadu.
account        migadu
host           ${MSMTP_HOST}
port           ${MSMTP_PORT}
from           ${MSMTP_FROM}
user           ${MSMTP_USER}
password       ${MSMTP_PASSWORD}

# Set a default account.
account default : migadu

