#! /bin/bash

# reload nginx config every 60 seconds in case certs get updated
while :; do
  sleep 60
  echo reloading
  nginx -s reload
done &

nginx -g 'daemon off;'
