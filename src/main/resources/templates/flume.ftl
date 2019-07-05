##
## ${dataModelBean.hiveTableName}落盘hdfs的配置
##
a${dataModelBean.hiveTableName}.sources = s52
a${dataModelBean.hiveTableName}.channels = c52
a${dataModelBean.hiveTableName}.sinks = k52

##a${dataModelBean.hiveTableName}的channel配置
a${dataModelBean.hiveTableName}.channels.c52.type = org.apache.flume.channel.kafka.KafkaChannel
#替换为kafka的地址
a${dataModelBean.hiveTableName}.channels.c52.kafka.bootstrap.servers =  kafka167:16792
#替换为kafka相关0f3f的topic名称
a${dataModelBean.hiveTableName}.channels.c52.kafka.topic =
a${dataModelBean.hiveTableName}.channels.c52.kafka.consumer.group.id = hdfs_${dataModelBean.hiveTableName}
a${dataModelBean.hiveTableName}.channels.c52.capacity = 100000
a${dataModelBean.hiveTableName}.channels.c52.parseAsFlumeEvent = false
a${dataModelBean.hiveTableName}.channels.c52.transactionCapacity = 10000
a${dataModelBean.hiveTableName}.channels.c52.pollTimeout = 500
a${dataModelBean.hiveTableName}.channels.c52.kafka.consumer.session.timeout.ms =  100000
a${dataModelBean.hiveTableName}.channels.c52.kafka.consumer.max.poll.interval.ms =  500000
a${dataModelBean.hiveTableName}.channels.c52.kafka.consumer.request.timeout.ms =   505000

##a${dataModelBean.hiveTableName}的sink配置
a${dataModelBean.hiveTableName}.sinks.k52.type = hdfs
#替换hdfs://aerocluster为实际hdfs的集群名称
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.path = hdfs://nhdp1.hadoop.com:8020/flume/qingqi/TA/%y-%m-%d/${dataModelBean.hiveTableName}/
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.filePrefix = a-k52
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.codeC=snappy
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.fileType=CompressedStream
a${dataModelBean.hiveTableName}.sinks.k52.serializer = com.navinfo.opentsp.platform.computing.serializer.${dataModelBean.className}$Builder
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.rollCount=30
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.rollInterval=0
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.rollSize=67108864
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.idleTimeout=60
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.minBlockReplicas=1
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.useLocalTimeStamp=true
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.batchSize = 10000
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.threadsPoolSize = 30
a${dataModelBean.hiveTableName}.sinks.k52.hdfs.rollTimerPoolSize = 5


##a${dataModelBean.hiveTableName}的sink和channel的关联配置
a${dataModelBean.hiveTableName}.sinks.k52.channel = c52