#!/bin/bash

# Get the directory of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the parent directory
parent_dir="$(dirname "$script_dir")"

# Set destination directory where to store PKI
destination_dir="$parent_dir/data/"

echo "Script directory: $script_dir"
echo "Parent directory: $parent_dir"
echo "Destination directory: $destination_dir"

# Create (initialize) a new PKI, as per:
# https://github.com/nginx-proxy/nginx-proxy/wiki/mTLS-client-side-certificate-authentication
docker run --rm -it \
 -u "$(id -u)" \
 -v $destination_dir:/data \
 theohbrothers/docker-easyrsa:latest init-pki
