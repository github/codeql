package org.springframework.web.bind.annotation;

import org.springframework.core.annotation.AliasFor;



public @interface RequestMapping {
    String name() default "";

    String[] value() default {};

    String[] path() default {};

    RequestMethod[] method() default {};
}
