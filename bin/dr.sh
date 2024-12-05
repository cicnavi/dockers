#!/usr/bin/env bash

IMAGE=${1:-08}
USER_GROUP=${2:-0}

CMD=${3:-bash}

docker run --rm --user "$USER_GROUP":"$USER_GROUP" -w /var/www/projects cicnavi/dap:"$IMAGE" $CMD
