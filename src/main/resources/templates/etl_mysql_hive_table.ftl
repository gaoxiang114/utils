--创建外部表
create external table if not exists ${dataModelBean.databaseName}.${dataModelBean.hiveTableName}_temp (
        operator_id                                       bigint              COMMENT '操作id',
        es                                                bigint              COMMENT '数据变更的时间戳',
        ts                                                bigint              COMMENT '时间戳',
        ddltype                                           string              COMMENT '操作类型',
<#list dataModelBean.fields as dataModel>
    <#if dataModel_index lt dataModelBean.size-1>
        ${dataModel.fieldName}<#list 1..(50-dataModel.fieldName?length) as i> </#list>${dataModel.fieldType}<#list 1..(20-dataModel.fieldType?length) as i> </#list>COMMENT '${dataModel.fieldMeaning}',
    <#else>
        ${dataModel.fieldName}<#list 1..(50-dataModel.fieldName?length) as i> </#list>${dataModel.fieldType}<#list 1..(20-dataModel.fieldType?length) as i> </#list>COMMENT '${dataModel.fieldMeaning}'
    </#if>
</#list>
) row format delimited fields terminated by '\001' STORED AS TEXTFILE location '${dataModelBean.tempTablePath}${dataModelBean.hiveTableName}';

--创建目标表
create table if not exists ${dataModelBean.databaseName}.${dataModelBean.hiveTableName}(
<#list dataModelBean.fields as dataModel>
    <#if dataModel_index lt dataModelBean.size-1>
        ${dataModel.fieldName}<#list 1..(50-dataModel.fieldName?length) as i> </#list>${dataModel.fieldType}<#list 1..(20-dataModel.fieldType?length) as i> </#list>COMMENT '${dataModel.fieldMeaning}',
    <#else>
        ${dataModel.fieldName}<#list 1..(50-dataModel.fieldName?length) as i> </#list>${dataModel.fieldType}<#list 1..(20-dataModel.fieldType?length) as i> </#list>COMMENT '${dataModel.fieldMeaning}'
    </#if>
</#list>
)
CLUSTERED BY (id) INTO 8 BUCKETS
STORED AS ORC TBLPROPERTIES ('transactional'='true','parquet.compression'='SNAPPY');
