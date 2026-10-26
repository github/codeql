// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonTypeInfo for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JacksonAnnotation;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.ANNOTATION_TYPE,java.lang.annotation.ElementType.TYPE,java.lang.annotation.ElementType.FIELD,java.lang.annotation.ElementType.METHOD,java.lang.annotation.ElementType.PARAMETER})
@JacksonAnnotation
public @interface JsonTypeInfo
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
