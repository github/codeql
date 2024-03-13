package org.springframework.security.config.annotation.web.configurers;

import org.springframework.security.config.annotation.SecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.HttpSecurityBuilder;
import org.springframework.security.web.DefaultSecurityFilterChain;

public abstract class AbstractHttpConfigurer<T extends AbstractHttpConfigurer<T, B>, B extends HttpSecurityBuilder<B>>
		extends SecurityConfigurerAdapter<DefaultSecurityFilterChain, B> {
	public B disable() { return null; }
}
