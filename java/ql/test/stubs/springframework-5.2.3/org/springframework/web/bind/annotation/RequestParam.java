package org.springframework.web.bind.annotation;

import java.lang.annotation.*;

@Target(value=ElementType.PARAMETER)
@Retention(value=RetentionPolicy.RUNTIME)
@Documented
public @interface RequestParam { }
