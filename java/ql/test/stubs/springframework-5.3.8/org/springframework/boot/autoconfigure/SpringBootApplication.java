package org.springframework.boot.autoconfigure;

import java.lang.annotation.Target;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;

import org.springframework.boot.SpringBootConfiguration;

@Target(ElementType.TYPE)
@Inherited
@SpringBootConfiguration
public @interface SpringBootApplication {}