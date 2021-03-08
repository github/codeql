package org.springframework.web.bind.annotation;

import org.springframework.core.annotation.AliasFor;

@RequestMapping
public @interface GetMapping {
   
    String name() default "";

    String[] value() default {};

    String[] path() default {};

    String[] params() default {};

    String[] consumes() default {};

    String[] produces() default {};
}
