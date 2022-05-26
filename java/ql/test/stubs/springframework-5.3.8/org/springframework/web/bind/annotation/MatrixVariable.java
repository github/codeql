// Generated automatically from org.springframework.web.bind.annotation.MatrixVariable for testing purposes

package org.springframework.web.bind.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.PARAMETER})
public @interface MatrixVariable
{
    String defaultValue() default "";
    String name() default "";
    String pathVar() default "";
    String value() default "";
    boolean required() default false;
}
