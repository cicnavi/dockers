#!/usr/bin/env bash

CONTAINER=${1:-74}
USER_GROUP=${2:-0}

docker exec -it --user "$USER_GROUP":"$USER_GROUP" -w /var/www/projects "$CONTAINER".dap.test bash
