// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.annotation.JsonSerialize for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JacksonAnnotation;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Converter;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.ANNOTATION_TYPE,java.lang.annotation.ElementType.METHOD,java.lang.annotation.ElementType.FIELD,java.lang.annotation.ElementType.TYPE,java.lang.annotation.ElementType.PARAMETER})
@JacksonAnnotation
public @interface JsonSerialize
{
    Class<? extends Converter<? extends Object, ? extends Object>> contentConverter();
    Class<? extends Converter<? extends Object, ? extends Object>> converter();
    Class<? extends JsonSerializer<? extends Object>> contentUsing();
    Class<? extends JsonSerializer<? extends Object>> keyUsing();
    Class<? extends JsonSerializer<? extends Object>> nullsUsing();
    Class<? extends JsonSerializer<? extends Object>> using();
    Class<? extends Object> as();
    Class<? extends Object> contentAs();
    Class<? extends Object> keyAs();
    JsonSerialize.Inclusion include();
    JsonSerialize.Typing typing();
    static public enum Inclusion
    {
        ALWAYS, DEFAULT_INCLUSION, NON_DEFAULT, NON_EMPTY, NON_NULL;
        private Inclusion() {}
    }
    static public enum Typing
    {
        DEFAULT_TYPING, DYNAMIC, STATIC;
        private Typing() {}
    }
}
