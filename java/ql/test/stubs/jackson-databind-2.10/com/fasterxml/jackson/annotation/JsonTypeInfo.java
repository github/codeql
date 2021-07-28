package com.fasterxml.jackson.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.ANNOTATION_TYPE, ElementType.TYPE, ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface JsonTypeInfo {
    JsonTypeInfo.Id use();

    public static enum Id {
        CLASS("@class"),
        MINIMAL_CLASS("@c");

        private Id(String defProp) { }

        public String getDefaultPropertyName() { return null; }
    }
}
