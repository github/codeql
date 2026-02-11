package com.semmle.e;

import com.semmle.d.DMarkerClass;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * This configuration is live because the config.xml file contains a component-scan element that
 * includes com.semmle.e as a base package.
 */
@Configuration
@ComponentScan(
    value = "com.semmle.a",
    basePackages = {"com.semmle.b", "com.semmle.c"},
    basePackageClasses = {DMarkerClass.class})
public class LiveConfiguration {}
