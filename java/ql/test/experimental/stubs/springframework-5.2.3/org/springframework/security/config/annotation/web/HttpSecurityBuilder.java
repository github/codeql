package org.springframework.security.config.annotation.web;

import org.springframework.security.config.annotation.SecurityBuilder;
import org.springframework.security.web.DefaultSecurityFilterChain;

public interface HttpSecurityBuilder<H extends HttpSecurityBuilder<H>> extends
		SecurityBuilder<DefaultSecurityFilterChain> {}
