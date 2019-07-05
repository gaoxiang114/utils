package com.navinfo.opentsp.platform.computing.serializer;

import com.google.common.base.Charsets;
import com.navinfo.opentsp.platform.computing.util.DateUtils;
import com.navinfo.stream.qingqi.protocol.java.${dataModelBean.javaOuterClassname};
import org.apache.commons.lang.StringUtils;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.serialization.EventSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.OutputStream;

/**
* ${dataModelBean.protocolField}信息
* HDFS_Sink的${dataModelBean.protocolField}序列化器，拼接成字段间通过\001分割的字符串
*/
public class ${dataModelBean.className} implements EventSerializer {
    private static final Logger logger = LoggerFactory.getLogger(${dataModelBean.className}.class);

    private final String APPEND_NEWLINE = "appendNewline";
    private final boolean appendNewline;
    private final String splitStr = "\001";
    private final OutputStream out;

    private ${dataModelBean.className}(OutputStream out, Context ctx) {
        this.appendNewline = ctx.getBoolean(APPEND_NEWLINE, true);
        this.out = out;
    }

    @Override
    public boolean supportsReopen() {
        return false;
    }
    @Override
    public void afterCreate() {}
    @Override
    public void afterReopen() {}
    @Override
    public void beforeClose() {}
    @Override
    public void flush() throws IOException {
        this.out.flush();
    }
    @Override
    public void write(Event event) throws IOException {
        try {
            //拼写落盘到HDFS的字符串。字段间分隔符是\001，null通过\N表示
            ${dataModelBean.javaOuterClassname}.${dataModelBean.protoMessageName} ${dataModelBean.protocolField} = ${dataModelBean.javaOuterClassname}.${dataModelBean.protoMessageName}.parseFrom(event.getBody());
            StringBuilder ${dataModelBean.protocolField}Str = new StringBuilder(5000);
            <#list dataModelBean.fields as dataModel>
                <#if dataModel.fieldDescription == 'repeated'>
                    ${dataModelBean.protocolField}Str.append(${dataModelBean.protocolField}.get${dataModel.methodName}(repeated类型需要人工处理)).append(splitStr);
                <#else>
                    ${dataModelBean.protocolField}Str.append(${dataModelBean.protocolField}.get${dataModel.methodName}()).append(splitStr);
                </#if>
            </#list>

            //添加字段只能在分割线之上添加,注意时间分区这块，终端传的时候是秒还是毫秒
            //------------------------------------------分割线----------------------------------------
            ${dataModelBean.protocolField}Str.append(DateUtils.format(${dataModelBean.protocolField}.getGpsTime() * 1000, "yyyyMMdd"));

            //将数据拼接后写入hdfs
            this.out.write(${dataModelBean.protocolField}Str.toString().getBytes(Charsets.UTF_8));
            if (this.appendNewline) {
                this.out.write(10);
            }
        }catch (Exception e){
            logger.error("执行HDFS的${dataModelBean.className}拦截器失败：" + e.getMessage(), e);
        }
    }

    public static class Builder implements EventSerializer.Builder {
        public Builder() { }
        @Override
        public EventSerializer build(Context context, OutputStream out) {
            return  new ${dataModelBean.className}(out, context);
        }
    }
}
