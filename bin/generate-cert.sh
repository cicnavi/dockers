#!/bin/bash

# Get the directory of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cert_name="${1:-dap}"

# Get the parent directory
parent_dir="$(dirname "$script_dir")"

# Set destination directory where to store PKI
destination_dir="$parent_dir/data/"

echo "Script directory: $script_dir"
echo "Parent directory: $parent_dir"
echo "Destination directory: $destination_dir"
echo "Cert name: $cert_name"

# Generate cert and key pair, as per:
# https://github.com/nginx-proxy/nginx-proxy/wiki/mTLS-client-side-certificate-authentication
docker run --rm -it \
 -u "$(id -u)" \
 -e EASYRSA_CERT_EXPIRE=3650 \
 -v $destination_dir:/data theohbrothers/docker-easyrsa:latest build-client-full "$cert_name" nopass
