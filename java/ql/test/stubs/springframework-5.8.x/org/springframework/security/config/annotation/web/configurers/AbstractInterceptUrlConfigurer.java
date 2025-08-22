package org.springframework.security.config.annotation.web.configurers;

import org.springframework.security.config.annotation.web.HttpSecurityBuilder;

abstract class AbstractInterceptUrlConfigurer<C extends AbstractInterceptUrlConfigurer<C, H>, H extends HttpSecurityBuilder<H>>
		extends AbstractHttpConfigurer<C, H> {
	abstract class AbstractInterceptUrlRegistry<R extends AbstractInterceptUrlRegistry<R, T>, T>
			extends AbstractConfigAttributeRequestMatcherRegistry<T> {
	}
}
