package org.springframework.boot;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

import org.springframework.context.annotation.Configuration;

@Target(ElementType.TYPE)
@Configuration
public @interface SpringBootConfiguration {}