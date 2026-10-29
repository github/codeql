package org.springframework.security.config.annotation.web.configurers;

import org.springframework.security.config.annotation.web.AbstractRequestMatcherRegistry;
import org.springframework.security.config.annotation.web.HttpSecurityBuilder;

public final class AuthorizeHttpRequestsConfigurer<H extends HttpSecurityBuilder<H>>
		extends AbstractHttpConfigurer<AuthorizeHttpRequestsConfigurer<H>, H> {

	public final class AuthorizationManagerRequestMatcherRegistry extends
			AbstractRequestMatcherRegistry<AuthorizedUrl> {
	}

	public class AuthorizedUrl {
		public AuthorizationManagerRequestMatcherRegistry permitAll() {
			return null;
		}

		public AuthorizationManagerRequestMatcherRegistry hasRole(String role) {
			return null;
		}
	}
}
