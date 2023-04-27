// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonInclude for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JacksonAnnotation;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.ANNOTATION_TYPE,java.lang.annotation.ElementType.METHOD,java.lang.annotation.ElementType.FIELD,java.lang.annotation.ElementType.TYPE,java.lang.annotation.ElementType.PARAMETER})
@JacksonAnnotation
public @interface JsonInclude
{
    JsonInclude.Include value();
    static public enum Include
    {
        ALWAYS, NON_DEFAULT, NON_EMPTY, NON_NULL;
        private Include() {}
    }
}
