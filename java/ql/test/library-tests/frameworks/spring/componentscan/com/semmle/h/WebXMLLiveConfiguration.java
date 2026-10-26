package com.semmle.h;

import org.springframework.context.annotation.Configuration;

/**
 * This configuration is live because the web.xml file specifies
 * AnnotationConfigWebApplicationContext as the {@code contextClass}, and has a
 * contextConfigLocation value that includes this package (com.semmle.h).
 */
@Configuration
public class WebXMLLiveConfiguration {}
