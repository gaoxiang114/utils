--创建外部表
create external table if not exists ${dataModelBean.databaseName}.${dataModelBean.hiveTableName}_temp (
<#list dataModelBean.fields as dataModel>
        ${dataModel.fieldName}<#list 1..(50-dataModel.fieldName?length) as i> </#list>${dataModel.fieldType}<#list 1..(20-dataModel.fieldType?length) as i> </#list>COMMENT '${dataModel.fieldMeaning}',
</#list>
        part_time<#list 1..41 as i> </#list>INT<#list 1..(17) as i> </#list>COMMENT '分区时间'
) row format delimited fields terminated by '\001' STORED AS TEXTFILE location '${dataModelBean.tempTablePath}${dataModelBean.hiveTableName}';

--创建目标表
create table if not exists ${dataModelBean.databaseName}.${dataModelBean.hiveTableName}(
<#list dataModelBean.fields as dataModel>
<#--    <#if dataModel_index lt dataModelBean.size-1>-->
        ${dataModel.fieldName}<#list 1..(50-dataModel.fieldName?length) as i> </#list>${dataModel.fieldType}<#list 1..(20-dataModel.fieldType?length) as i> </#list>COMMENT '${dataModel.fieldMeaning}',
<#--    <#else>-->
<#--        ${dataModel.fieldName}<#list 1..(50-dataModel.fieldName?length) as i> </#list>${dataModel.fieldType}<#list 1..(20-dataModel.fieldType?length) as i> </#list>COMMENT '${dataModel.fieldMeaning}'-->
<#--    </#if>-->
</#list>
        create_time<#list 1..39 as i> </#list>STRING<#list 1..(14) as i> </#list>COMMENT '数据创建时间'
) partitioned by (part_time int) stored as Parquet TBLPROPERTIES('parquet.compression'='SNAPPY');
