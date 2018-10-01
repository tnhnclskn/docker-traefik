#!/bin/bash
STACK_DIR=$(basename "$PWD")
STACK_NAME=${STACK_DIR//[-._]/}

stack_up () {
    docker network create --driver=overlay traefik-net
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

