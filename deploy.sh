#!/bin/bash
read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

STACK_DIR=$(basename "$PWD")
STACK_NAME=${STACK_DIR//[-._]/}
TRAEFIK_NETWORK_NAME=$(read_var TRAEFIK_NETWORK_NAME .env)

stack_up () {
    IS_NETWORK_EXISTS=$(($(docker network ls -f name=traefik-net | wc -l) - 1))
    if [[ $IS_NETWORK_EXISTS == 0 ]]; then
        docker network create --driver=overlay $TRAEFIK_NETWORK_NAME
    fi
    env $(cat .env | xargs) docker stack deploy -c docker-compose.yml $STACK_NAME
}

stack_down () {
    env $(cat .env | xargs) docker stack rm $STACK_NAME
}

stack_services () {
    env $(cat .env | xargs) docker stack services $STACK_NAME
}

case "$1" in
    'up')
        stack_up;
        ;;
    'down')
        stack_down;
        ;;
    're-up')
        stack_down;
        sleep 2
        stack_up;
        ;;
    'services')
        stack_services;
        ;;
esac