#!/bin/bash

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

if [ ! -n "$BACKUP_FILENAME" ]; then
  echo "need -f param for backup file."
  exit 1
fi

if [ ! -n "$RESTORE_PATH" ]; then
  echo "need -d param for vaultwarden data path."
  exit 2
fi

if [ ! -n "$PASSWD" ]; then
  echo "need -p param for backup password."
  exit 3
fi

openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -pass pass:${PASSWD} -in ${BACKUP_FILENAME} | tar zxvf - -C ${RESTORE_PATH}
