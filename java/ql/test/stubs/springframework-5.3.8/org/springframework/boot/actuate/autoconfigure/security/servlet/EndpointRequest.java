package org.springframework.boot.actuate.autoconfigure.security.servlet;

import org.springframework.boot.security.servlet.ApplicationContextRequestMatcher;
import org.springframework.web.context.WebApplicationContext;

public final class EndpointRequest {
	public static EndpointRequestMatcher toAnyEndpoint() {
		return null;
  }

  public static EndpointRequestMatcher to(String... endpoints) {
		return null;
	}
  
  public static final class EndpointRequestMatcher extends AbstractRequestMatcher {}

  private abstract static class AbstractRequestMatcher
			extends ApplicationContextRequestMatcher<WebApplicationContext> {}
}
