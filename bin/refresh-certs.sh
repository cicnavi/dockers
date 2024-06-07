#!/bin/bash

# Get the directory of the script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the parent directory
parent_dir="$(dirname "$script_dir")"

# Set destination directory where to store the downloaded files
cert_destination_dir="$parent_dir/nginx-proxy/certs/"

echo "Script directory: $script_dir"
echo "Parent directory: $parent_dir"
echo "Cert destination directory: $cert_destination"

# Download existing certificates and give them expected file name
# localhost.markoivancic.from.hr source
source="https://certs.markoivancic.from.hr/localhost.markoivancic.from.hr/"
wget "${source}fullchain.pem" -O "${cert_destination_dir}localhost.markoivancic.from.hr.crt"
wget "${source}key.pem" -O "${cert_destination_dir}localhost.markoivancic.from.hr.key"
