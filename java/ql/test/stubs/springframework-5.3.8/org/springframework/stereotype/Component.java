package org.springframework.stereotype;

import java.lang.annotation.*;

@Target(value=ElementType.TYPE)
@Retention(value=RetentionPolicy.RUNTIME)
@Documented
@Indexed
public @interface Component { }