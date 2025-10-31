#!/bin/bash

APP_DIR="/home/ubuntu/app"
WATCH_PATH="${APP_DIR}/docker/docker-compose.yml"
ENV_FILE="${APP_DIR}/.env"

EVENT="modify,close_write,moved_to,attrib" 

while true; do
    if inotifywait -e ${EVENT} ${WATCH_PATH}; then
        docker compose --env-file ${ENV_FILE} -f ${WATCH_PATH} pull
        docker compose --env-file ${ENV_FILE} -f ${WATCH_PATH} up -d
    fi
done