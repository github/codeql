package org.springframework.security.config.annotation.web.builders;

import org.springframework.security.config.annotation.AbstractConfiguredSecurityBuilder;
import org.springframework.security.config.annotation.SecurityBuilder;
import org.springframework.security.config.annotation.web.HttpSecurityBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity.RequestMatcherConfigurer;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.configurers.CsrfConfigurer;
import org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer;
import org.springframework.security.config.annotation.web.AbstractRequestMatcherRegistry;

public final class HttpSecurity extends AbstractConfiguredSecurityBuilder<DefaultSecurityFilterChain, HttpSecurity>
		implements SecurityBuilder<DefaultSecurityFilterChain>, HttpSecurityBuilder<HttpSecurity> {

	public HttpSecurity requestMatcher(RequestMatcher requestMatcher) {
		return this;
	}

	public HttpSecurity authorizeRequests(
			Customizer<ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry> authorizeRequestsCustomizer)
			throws Exception {
		return this;
	}

	public ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry authorizeRequests()
			throws Exception {
		return null;
	}

	public HttpSecurity requestMatchers(Customizer<RequestMatcherConfigurer> requestMatcherCustomizer) {
		return this;
	}

	public RequestMatcherConfigurer requestMatchers() {
		return null;
	}

	public CsrfConfigurer<HttpSecurity> csrf() {
		return null;
	}

	public HttpSecurity csrf(Customizer<CsrfConfigurer<HttpSecurity>> csrfCustomizer) {
		return null;
	}

	public final class MvcMatchersRequestMatcherConfigurer extends RequestMatcherConfigurer {
	}

	public class RequestMatcherConfigurer extends AbstractRequestMatcherRegistry<RequestMatcherConfigurer> {
	}
}
