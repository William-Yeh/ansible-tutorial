#!/bin/bash

if [ -f /etc/lsb-release ]; then      # Ubuntu

    . /etc/lsb-release
    APT_OS_NAME=${DISTRIB_ID,,}
    APT_OS_VERSION=$DISTRIB_CODENAME

elif [ -f /etc/os-release ]; then     # Debian

    . /etc/os-release
    APT_OS_NAME=$ID

    if [[ "$VERSION" =~ [0-9]+[[:space:]]+\((.+)\)$ ]]; then
        APT_OS_VERSION=${BASH_REMATCH[1]}
    else
	    echo "ERROR: Unknown Debian format..."
	    exit 1
	fi

else
	echo "ERROR: Neithor Debian nor Ubuntu..."
	exit 1
fi



echo "deb http://nginx.org/packages/$APT_OS_NAME/ $APT_OS_VERSION nginx"  \
  |  sudo tee /etc/apt/sources.list.d/nginx.list

echo "deb-src http://nginx.org/packages/$APT_OS_NAME/ $APT_OS_VERSION nginx" \
  |  sudo tee -a /etc/apt/sources.list.d/nginx.list

curl -sSL http://nginx.org/keys/nginx_signing.key \
  |  sudo apt-key add -

apt-get update
apt-get install -y nginx



sed -i 's/^\(worker_processes\s*\)1;/\1auto;/'   \
    /etc/nginx/nginx.conf

service nginx restart
