// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonAutoDetect for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Member;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JacksonAnnotation;

@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.ANNOTATION_TYPE,java.lang.annotation.ElementType.TYPE})
@JacksonAnnotation
public @interface JsonAutoDetect
{
    JsonAutoDetect.Visibility creatorVisibility();
    JsonAutoDetect.Visibility fieldVisibility();
    JsonAutoDetect.Visibility getterVisibility();
    JsonAutoDetect.Visibility isGetterVisibility();
    JsonAutoDetect.Visibility setterVisibility();
    static public enum Visibility
    {
        ANY, DEFAULT, NONE, NON_PRIVATE, PROTECTED_AND_PUBLIC, PUBLIC_ONLY;
        private Visibility() {}
        public boolean isVisible(Member p0){ return false; }
    }
}
