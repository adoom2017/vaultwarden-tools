#!/bin/bash

. /app/common.sh

DATA_PATH=/vaultwarden/data
BACKUP_PATH=/vaultwarden/backup
CRON_FILE=/vaultwarden/crontabs

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
        -c|--cron)
            shift
            CRON="$1"
            shift
            ;;
        -k|--keep)
            shift
            KEEP="$1"
            shift
            ;;
    esac
done

function configure_cron() {
    CRON="${CRON:-"5 1 * * *"}"
    KEEP="${KEEP:-"30"}"

    local COUNT="$(grep -c 'backup.sh' "${CRON_FILE}" 2> /dev/null)"
    if [[ "${COUNT}" -eq 0 ]]; then
        echo "${CRON} bash /app/backup.sh -s ${DATA_PATH} -d ${BACKUP_PATH} -p ${PASSWORD} -k ${KEEP}" >> "${CRON_FILE}"
    fi
}

check_param $TYPE "-t or --type"

case "$TYPE" in
    restore)
        check_param ${FILENAME} "-f or --filename"
        check_param ${PASSWORD} "-p or --password"
        /app/restore.sh -f ${BACKUP_PATH}/${FILENAME} -d ${DATA_PATH} -p ${PASSWORD} > /dev/null 2>&1

	check_result "Failed to restore bitwarden data"

        color blue "Succeed to restore bitwarden data."
        exit 0
        ;;
    backup)
        check_param ${PASSWORD} "-p or --password"
        /app/backup.sh -s ${DATA_PATH} -d ${BACKUP_PATH} -p ${PASSWORD} > /dev/null 2>&1

	check_result "Failed to backup bitwarden data."

        color blue "Succeed to backup bitwarden data."
        exit 0
        ;;
    auto)
	check_param ${PASSWORD} "-p or --password"
	configure_cron
        
        # crond run foreground
        exec supercronic -passthrough-logs -quiet "${CRON_FILE}"
	exit 0
	;;
    *)
        color red "The \"-t\" or \"--type\" parameter must in \"backup\" \"restore\" \"auto\"."
        exit 1
        ;;
esac

