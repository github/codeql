package org.springframework.security.config.annotation.web;

import org.springframework.security.web.util.matcher.RequestMatcher;

public abstract class AbstractRequestMatcherRegistry<C> {
  public C anyRequest() {
    return null;
  }
  
  public C requestMatchers(RequestMatcher... requestMatchers) {
		return null;
	}
}
