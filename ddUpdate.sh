#!/bin/bash

# Read conf file from same location as script
_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. $_SCRIPT_DIR/rnsupdate.conf


debugEcho () {
  [[ "$debug" ]] && builtin echo $@ >&2
}

_usage(){
  echo "Usage: $(basename $0) [--hostname home.example.com] [--ipAddress 192.168.1.1] [--forceUpdate]"
}

_setArgs(){
  while [ "$1" != "" ]; do
    case $1 in
      "-h" | "--hostname")
        debugEcho $1 $2
        shift
        hostname=$1
        ;;
      "-i" | "--ipAddress")
        debugEcho $1 $2
        shift
        ipAddress=$1
        ;;
      "-f" | "--forceUpdate")
        debugEcho $1
        forceUpdate=true
        ;;
      "--help")
        debugEcho $1
        _usage
        exit 0
        ;;
      "-d" | "--debug")
        debug=true
        debugEcho $1
        ;;
    esac
    shift
  done
  
  debugEcho "Args read."
}


ipcheckURL='https://api.ipify.org'

_getMyPublicIP(){
  local command="/usr/bin/curl -sS $ipcheckURL"
  debugEcho $command
  local ip=$($command)
  debugEcho $ip
  echo $ip
}

_getMyHostname(){
  local command="/bin/hostname"
  debugEcho $command
  local hostname=$($command)
  debugEcho $hostname
  echo $hostname
}

_getCurrentDNS(){
  local command="/usr/bin/dig +noall +answer +short $1"
  debugEcho $command
  local currentDDNS=$($command)
  debugEcho $currentDDNS
  echo $currentDDNS
}

_updateDNS(){
  local hostname=$1
  local ipAddress=$2
  
  $NSUPDATE_COMMAND <<EOF
server ${DNS_SERVER}
zone ${DDNS_ZONE}
del ${hostname} A
add ${hostname} 0 A ${ipAddress}
send
quit
EOF
}

_setArgs $*

# if not set on command line, get using the default methods
[ -z "$hostname" ] && hostname=$(_getMyHostname)
[ -z "$ipAddress" ] && ipAddress=$(_getMyPublicIP)

# get the current value set in DNS
currentDNS=$(_getCurrentDNS $hostname)

# decide if an update is necessary
if ( ! [ -z "$forceUpdate" ] ) || \
    [ -z "$currentDNS" ] || \
    [ "$currentDNS" != "$ipAddress" ]
then
  _updateDNS $hostname $ipAddress
fi