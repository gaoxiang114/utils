#!/bin/sh
if [ -z $1 ];then
hive_db=default
else
hive_db=$1
fi

if [ -z $2 ];then
create_time=`date  "+%Y-%m-%d-%H-%M-%S"`
else
create_time=$2
fi

hiveconfig=$(cat <<"EOF" /home/hdfs/parquet_shell/hive_parquet_scripts/hive.config
EOF
)

sql_suffix=$(cat <<EOF
        INSERT INTO TABLE ${dataModelBean.databaseName}.${dataModelBean.hiveTableName} PARTITION (part_time) SELECT ${dataModelBean.fieldListString},'${r'${create_time}'}',part_time, hashtid FROM ${dataModelBean.databaseName}.${dataModelBean.hiveTableName};
EOF
)
sql="${r'${hiveconfig}${sql_suffix}'}"
############  execute begin   ###########
hive -e  "$sql"
#echo $sql