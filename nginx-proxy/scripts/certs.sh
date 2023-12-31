#!/usr/bin/env bash

set -e
shopt -s extglob

# Moved to nginx reverse proxy with certs
# Get cert and key for *.markoivancic.from.hr
#MI_CERT_URL="https://certs.markoivancic.from.hr"
#MI_CERT_FILES=( "cer.pem" "fullchain.pem" "key.pem")
#MI_DOMAINS=( "localhost.markoivancic.from.hr" )
#
#MI_CERT_DIR="/etc/apache2/shared-config-from-host/ssl"
#
#for MI_DOMAIN in "${MI_DOMAINS[@]}"; do
#  MI_CERT_DIR_DOMAIN="${MI_CERT_DIR}"/"${MI_DOMAIN}"
#  mkdir -p "${MI_CERT_DIR_DOMAIN}";
#  for MI_CERT_FILE in "${MI_CERT_FILES[@]}"; do
#    wget -O "${MI_CERT_DIR_DOMAIN}"/"${MI_CERT_FILE}" "${MI_CERT_URL}"/"${MI_DOMAIN}"/"${MI_CERT_FILE}"
#  done
#
#  chown www-data:www-data "${MI_CERT_DIR_DOMAIN}"/*
#  chmod 400 "${MI_CERT_DIR_DOMAIN}"/*
#done

