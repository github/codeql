// Generated automatically from org.springframework.web.bind.annotation.RequestMapping for testing purposes

package org.springframework.web.bind.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Documented
@Mapping
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD,ElementType.TYPE})
public @interface RequestMapping
{
    RequestMethod[] method() default {};
    String name() default "";
    String[] consumes() default {};
    String[] headers()  default {};
    String[] params()  default {};
    String[] path()  default {};
    String[] produces()  default {};
    String[] value()  default {};
}
