// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.annotation.JsonPOJOBuilder for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JacksonAnnotation;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.ANNOTATION_TYPE,java.lang.annotation.ElementType.TYPE})
@JacksonAnnotation
public @interface JsonPOJOBuilder
{
    String buildMethodName();
    String withPrefix();
    static public class Value
    {
        protected Value() {}
        public Value(JsonPOJOBuilder p0){}
        public final String buildMethodName = null;
        public final String withPrefix = null;
    }
}
