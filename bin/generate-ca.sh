#!/bin/bash

# Get the directory of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the parent directory
parent_dir="$(dirname "$script_dir")"

# Set destination directory where to store PKI
destination_dir="$parent_dir/data/"
nginx_certs_dir="$parent_dir/nginx-proxy/certs"

echo "Script directory: $script_dir"
echo "Parent directory: $parent_dir"
echo "Destination directory: $destination_dir"

# Generate CA, as per:
# https://github.com/nginx-proxy/nginx-proxy/wiki/mTLS-client-side-certificate-authentication
docker run --rm -it \
 -u "$(id -u)" \
 -v $destination_dir:/data theohbrothers/docker-easyrsa:latest build-ca nopass

echo "Copying ca.crt to nginx certs dir."
cp -f "$destination_dir/pki/ca.crt" "$nginx_certs_dir/"
