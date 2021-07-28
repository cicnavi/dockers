#!/usr/bin/env bash

set -e
shopt -s extglob

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MI_TAGS=( "56" "74" "80" )

docker login

for MI_TAG in "${MI_TAGS[@]}"; do
  docker build -t cicnavi/dap:"$MI_TAG" -f "$CURRENT_DIR"/../dap/"$MI_TAG"/Dockerfile "$CURRENT_DIR"/../dap
  docker push cicnavi/dap:"$MI_TAG"
done
