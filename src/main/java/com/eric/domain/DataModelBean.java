package com.eric.domain;

import lombok.Data;

import java.util.List;

@Data
public class DataModelBean {
    private String className;
    private String javaOuterClassname;
    private String protoMessageName;
    private String protocolField;
    private String databaseName;
    private String hiveTableName;
    private String tempTablePath;
    private List<DataModel> fields;
    private String fieldListString;
    private int size;

    @Data
    public static class DataModel {
        private String fieldName;
        private String methodName;
        private String fieldType;
        private String fieldDescription;
        private String fieldMeaning;
    }
}
