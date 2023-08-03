#!/bin/bash
. /app/common.sh

#获取参数
while getopts ":f:d:p:" opt
do
  case $opt in
    f)
      BACKUP_FILENAME=$OPTARG
      ;;
    d)
      RESTORE_PATH=$OPTARG
      ;;
    p)
      PASSWD=$OPTARG
      ;;
    ?)
      echo "unknow param"
      exit 1
      ;;
  esac
done

openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -pass pass:${PASSWD} -in ${BACKUP_FILENAME} | tar zxvf - -C ${RESTORE_PATH}
check_result "Unpacking the backup file failed."

