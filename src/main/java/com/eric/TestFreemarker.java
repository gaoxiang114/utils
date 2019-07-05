package com.eric;

import com.eric.domain.DataModelBean;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.apache.commons.lang3.StringUtils;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TestFreemarker {
    public static String TEMPLATE_PATH = "D:\\workspace\\eric_utils\\src\\main\\resources";
    public static String OUTPUT_PATH = "E:\\hive_parquet_file";
    public static void main(String[] args) throws IOException {
        String modelPath = args[0];
        String templatePath = args[1];
        String output_path= args[2];
        DataModelBean dataModelBean = parseFile(modelPath);
        String fileName = "hive_parquet_insert_" + dataModelBean.getHiveTableName() + ".sh";
        generatorFile(templatePath,"hive_parquet_insert.ftl", fileName, dataModelBean,output_path);
        fileName = dataModelBean.getClassName() + ".java";
        generatorFile(templatePath,"ProtocolSerializer.ftl", fileName, dataModelBean,output_path);
        fileName = "hive_create_table_"+dataModelBean.getHiveTableName()+".hql";
        generatorFile(templatePath,"hive_protocol_table.ftl", fileName, dataModelBean,output_path);
        fileName = "flume.config";
        generatorFile(templatePath,"flume.ftl", fileName, dataModelBean,output_path);
        fileName = "etl_mysql_hive_table.hql";
        generatorFile(templatePath, "etl_mysql_hive_table.ftl", fileName, dataModelBean,output_path);
    }

    public static void generatorFile(String templatePath,String templateName, String fileName,DataModelBean dataModelBean,String output_path){
        Configuration configuration = new Configuration(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS);
        Writer out = null;
        try {
            configuration.setDirectoryForTemplateLoading(new File(templatePath));
            Map<String, Object> dataMap = new HashMap<String, Object>();
            dataMap.put("dataModelBean",dataModelBean);
            Template template = configuration.getTemplate(templateName);
            File file = new File(output_path);
            if (!file.exists()) {
                file.mkdirs();
            }
            File docFile = new File(output_path + File.separator + fileName);
            out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(docFile)));
            template.process(dataMap, out);
            System.out.println("^^^^^^^^^^^^^^^^^^^^^^^^"  + fileName + "文件创建成功 !");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (null != out) {
                    out.flush();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }

    public static DataModelBean parseFile(String dataPath) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader(new File(dataPath)));
        String line = null;
        int n = 0;
        DataModelBean dataModelBean = new DataModelBean();
        List<DataModelBean.DataModel> fields = new ArrayList<>();
        List<String> fieldList = new ArrayList<>();
        while((line=bufferedReader.readLine())!=null){
            if("".equals(line) || line.startsWith("###")){
                continue;
            }
            String[] fieldArray = line.split(",");
            if(n == 0) {
                dataModelBean.setClassName(fieldArray[0]);
                dataModelBean.setJavaOuterClassname(fieldArray[1]);
                dataModelBean.setProtoMessageName(fieldArray[2]);
                dataModelBean.setProtocolField(fieldArray[3]);
                n++;
            } else if(n > 0 && n < 2){
                dataModelBean.setDatabaseName(fieldArray[0]);
                dataModelBean.setHiveTableName(fieldArray[1]);
                dataModelBean.setTempTablePath(fieldArray[2]);
                n++;
            } else {
                DataModelBean.DataModel dataModel = new DataModelBean.DataModel();
                dataModel.setFieldName(fieldArray[0]);
                if(fieldArray[2].equals("repeated")){
                    dataModel.setFieldType(transformType("list"));
                } else {
                    dataModel.setFieldType(transformType(fieldArray[1]));
                }
                String fieldMeaning = "";
                if(fieldArray.length == 4){
                    fieldMeaning = fieldArray[3];
                }
                dataModel.setFieldDescription(fieldArray[2]);
                dataModel.setFieldMeaning(fieldMeaning);
                dataModel.setMethodName(dataModel.getFieldName().substring(0, 1).toUpperCase() + dataModel.getFieldName().substring(1));
                fields.add(dataModel);
                fieldList.add(fieldArray[0]);
            }
        }
        dataModelBean.setFields(fields);
        dataModelBean.setSize(fields.size());
        dataModelBean.setFieldListString(StringUtils.join(fieldList, ","));
        return dataModelBean;
    }

    public static String transformType(String type){
        String returnType = "STRING";
        switch (type) {
            case "int32":
                returnType = "INT";
                break;
            case "int64":
                returnType = "BIGINT";
                break;
            case "bool":
                returnType = "BOOLEAN";
                break;
            case "string":
                returnType = "STRING";
                break;
            default:
                returnType = "STRING";
                break;
        }
        return returnType;
    }
}
