#!/bin/bash

#获取参数
while getopts ":s:d:p:" opt
do
  case $opt in
    s)
      SOURCE=$OPTARG
      ;;
    d)
      DEST=$OPTARG
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

if [ ! -n "$SOURCE" ]; then
  echo "need -s param for vaultwarden data path."
  exit 1
fi

if [ ! -n "$DEST" ]; then
  echo "need -d param for vaultwarden backup path."
  exit 2
fi

if [ ! -n "$PASSWD" ]; then
  echo "need -p param for backup password."
  exit 3
fi

NOW=$(date '+%Y%m%d%H%M')

DATA_PATH=${SOURCE}
BACKUP_PATH=${DEST}/$NOW
BACKUP_FILENAME=${DEST}/bit-$NOW.tar.gz

if [ ! -d "${BACKUP_PATH}" ]; then
  mkdir -p ${BACKUP_PATH}
fi

#备份数据库
sqlite3 ${DATA_PATH}/db.sqlite3 ".backup '${BACKUP_PATH}/db.sqlite3'"
#备份附件
cp -rf ${DATA_PATH}/attachments ${BACKUP_PATH}/
#备份sends
cp -rf ${DATA_PATH}/sends ${BACKUP_PATH}/
#备份配置
cp -rf ${DATA_PATH}/config.json ${BACKUP_PATH}/config.json
#备份密钥
cp -rf ${DATA_PATH}/rsa_key* ${BACKUP_PATH}/

#加密打包
tar czvf - -C ${BACKUP_PATH} . | openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 1000000 -salt -pass pass:${PASSWD} -out ${BACKUP_FILENAME}
rm -rf ${BACKUP_PATH}

