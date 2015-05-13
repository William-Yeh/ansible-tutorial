#!/bin/bash

echo "deb http://nginx.org/packages/ubuntu/ trusty nginx"  \
  |  sudo tee /etc/apt/sources.list.d/nginx.list

echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" \
  |  sudo tee -a /etc/apt/sources.list.d/nginx.list

curl -sSL http://nginx.org/keys/nginx_signing.key \
  |  sudo apt-key add -

apt-get update
apt-get install -y nginx
