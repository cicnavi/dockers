#!/usr/bin/env bash

set -e
shopt -s extglob

/var/scripts/certs.sh

echo "Starting apache"
apache2-foreground