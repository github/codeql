package org.springframework.web.bind.annotation;

import org.springframework.core.annotation.AliasFor;

public @interface RequestMapping {
    String name() default "";

    @AliasFor("path")
    String[] value() default {};

    @AliasFor("value")
    String[] path() default {};

    RequestMethod[] method() default {};
}
