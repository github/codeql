package com.semmle.f;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/** This is a dead configuration class, because this class is not in a registered base package. */
@Configuration
@ComponentScan("com.semmle.f")
public class DeadConfiguration {}
