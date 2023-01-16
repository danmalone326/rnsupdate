#!/bin/sh

/bin/cat /etc/letsencrypt/live/router-internal.malone.org/fullchain.pem | /usr/bin/ssh udm-cert-update "cert"
/bin/cat /etc/letsencrypt/live/router-internal.malone.org/privkey.pem | /usr/bin/ssh udm-cert-update "key"
ssh udm-cert-update "restart

