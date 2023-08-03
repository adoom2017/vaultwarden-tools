#!/bin/bash

. /app/common.sh

function clear_history() {
    local FILES_DEL=$(find $1 -maxdepth 1 -name "bit-*" -type f -printf '%T@ %p\n' | sort -n | head -n -$2 | cut -d' ' -f2-)
    # delete files
    if [ -n "${FILES_DEL}" ]; then
        color blue  "Keep the latest $2 files, the following files will be deleted."
        color blue  "${FILES_DEL}"
        rm -f "${FILES_DEL}"
    else
        color blue "There were no files need to be deleted."
    fi
}

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
    k)
      KEEP_DAYS=$OPTARG
      ;;
    ?)
      echo "Unknow param."
      exit 1
      ;;
  esac
done

NOW=$(date '+%Y%m%d%H%M')

DATA_PATH=${SOURCE}
BACKUP_PATH=${DEST}/$NOW
BACKUP_FILENAME=${DEST}/bit-$NOW.tar.gz

if [ ! -d "${BACKUP_PATH}" ]; then
  mkdir -p ${BACKUP_PATH}
fi

#备份数据库
sqlite3 ${DATA_PATH}/db.sqlite3 ".backup '${BACKUP_PATH}/db.sqlite3'"
check_result "Failed to backup sqlite3 data file."

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
check_result "Failed package data files."

#删除临时备份路径
rm -rf ${BACKUP_PATH}

#删除备份过期备份文件
clear_history ${BACKUP_PATH} ${KEEP_DAYS}

