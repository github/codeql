package org.springframework.security.config.annotation;

public abstract class SecurityConfigurerAdapter<O, B extends SecurityBuilder<O>>
		implements SecurityConfigurer<O, B> {}
