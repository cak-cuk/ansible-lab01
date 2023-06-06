#!/bin/bash

get_distribution() {
        lsb_dist=""
        # Every system that we officially support has /etc/os-release
        if [ -r /etc/os-release ]; then
                lsb_dist="$(. /etc/os-release && echo "$ID")"
        fi
        # Returning an empty string here should be alright since the
        # case statements don't act unless you provide an actual value
        echo "$lsb_dist"
}

lsb_dist=$( get_distribution )
lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"

case "$lsb_dist" in

  ubuntu|debian|raspbian)
      echo "This is Debian based"
      sudo apt update
      sudo apt install -y python3-pip
  ;;
  centos|rhel|sles)
      echo "This is RedHat"
      sudo localedef -c -f UTF-8 -i en_US en_US.UTF-8
      export LANG='en_US.UTF-8'
      export LC_ALL=en_US.UTF-8
      sudo yum install -y python3-pip libselinux-python3 iproute
  ;;
  *)
      echo "Unsupported Linux Distro, app will quit"
      exit 0
  ;;
esac
