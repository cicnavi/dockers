#!/usr/bin/env bash

set -e
shopt -s extglob

/var/scripts/certs.sh

echo "Please wait..."
sleep 1

echo "Starting apache"
apache2-foreground