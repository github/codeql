package org.springframework.security.config.annotation.web.configurers;

import org.springframework.security.config.annotation.web.HttpSecurityBuilder;

public class CsrfConfigurer<H extends HttpSecurityBuilder<H>>
        extends AbstractHttpConfigurer<CsrfConfigurer<H>, H> {

}
