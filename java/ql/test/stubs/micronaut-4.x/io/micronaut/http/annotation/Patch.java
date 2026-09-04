package io.micronaut.http.annotation;

import java.lang.annotation.*;

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
public @interface Patch {
    String value() default "/";
    String uri() default "/";
}
