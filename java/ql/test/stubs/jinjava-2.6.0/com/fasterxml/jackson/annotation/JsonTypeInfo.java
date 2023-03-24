// Generated automatically from com.fasterxml.jackson.annotation.JsonTypeInfo for testing purposes

package com.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;

public interface JsonTypeInfo extends Annotation
{
    Class<? extends Object> defaultImpl();
    JsonTypeInfo.As include();
    JsonTypeInfo.Id use();
    String property();
    boolean visible();
    static public enum As
    {
        EXISTING_PROPERTY, EXTERNAL_PROPERTY, PROPERTY, WRAPPER_ARRAY, WRAPPER_OBJECT;
        private As() {}
    }
    static public enum Id
    {
        CLASS, CUSTOM, MINIMAL_CLASS, NAME, NONE;
        private Id() {}
        public String getDefaultPropertyName(){ return null; }
    }
}
