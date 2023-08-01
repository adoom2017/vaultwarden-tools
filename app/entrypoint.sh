#!/bin/bash

DATA_PATH=/vaultwarden/data
BACKUP_PATH=/vaultwarden/backup

function color() {
    case $1 in
        red)     echo -e "\033[31m$2\033[0m" ;;
        green)   echo -e "\033[32m$2\033[0m" ;;
        yellow)  echo -e "\033[33m$2\033[0m" ;;
        blue)    echo -e "\033[34m$2\033[0m" ;;
        none)    echo "$2" ;;
    esac
}

function check_param() {
    if [ ! -n "$1" ]; then
        color red "Please specify parameter $2."
        exit 1
    fi
}

# get param
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--type)
            shift
            TYPE="$1"
            shift
            ;;
        -p|--password)
            shift
            PASSWORD="$1"
            shift
            ;;
        -f|--filename)
            shift
            FILENAME="$1"
            shift
            ;;
    esac
done

check_param $TYPE "-t or --type"

case "$TYPE" in
    restore)
        check_param ${FILENAME} "-f or --filename"
        check_param ${PASSWORD} "-p or --password"
        /app/restore.sh -f ${BACKUP_PATH}/${FILENAME} -d ${DATA_PATH} -p ${PASSWORD} > /dev/null 2>&1

        if [[ $? != 0 ]]; then 
            color red "Failed to restore bitwarden data."
            exit 1
        fi

        color blue "Succeed to restore bitwarden data."
        exit 0
        ;;
    backup)
        check_param ${PASSWORD} "-p or --password"
        /app/backup.sh -s ${DATA_PATH} -d ${BACKUP_PATH} -p ${PASSWORD} > /dev/null 2>&1

        if [[ $? != 0 ]]; then
            color red "Failed to backup bitwarden data."
            exit 1
        fi

        color blue "Succeed to backup bitwarden data."
        exit 0
        ;;
    *)
        color red "The \"-t\" or \"--type\" parameter must be set to either \"backup\" or \"restore\"."
        exit 1
        ;;
esac
