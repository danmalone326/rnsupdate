#!/bin/sh
#
# You can have only one forced command in ~/.ssh/authorized_keys. Use this
# wrapper to allow several commands.

case "$SSH_ORIGINAL_COMMAND" in
    "cert")
        /bin/cat > /mnt/data/unifi-os/unifi-core/config/unifi-core.crt
        ;;
    "key")
        /bin/cat > /mnt/data/unifi-os/unifi-core/config/unifi-core.key
        ;;
    "restart")
        unifi-os restart
        ;;
    *)
        echo "Access denied"
        exit 1
        ;;
esac

