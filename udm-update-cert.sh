#!/bin/sh
#
# add this to /etc/letsencrypt/renewal/<domain>.conf as
# renew_hook = /path/to/udm-update-cert.sh
#
/bin/cat /etc/letsencrypt/live/router-internal.malone.org/fullchain.pem | /usr/bin/ssh udm-update-cert "cert"
/bin/cat /etc/letsencrypt/live/router-internal.malone.org/privkey.pem | /usr/bin/ssh udm-update-cert "key"
/usr/bin/ssh udm-update-cert "restart"

