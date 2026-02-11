// Generated automatically from org.springframework.web.bind.annotation.SessionAttribute for testing purposes

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
public @interface SessionAttribute
{
    String name() default "";
    String value() default "";
    boolean required() default false;
}
