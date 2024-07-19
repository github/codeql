package org.springframework.security.config.web.server;

import org.springframework.security.config.Customizer;

public class ServerHttpSecurity {
    private CsrfSpec csrf = new CsrfSpec();

    protected ServerHttpSecurity() {
    }

    public CsrfSpec csrf() {
      if (this.csrf == null) {
        this.csrf = new CsrfSpec();
      }
      return this.csrf;
    }

    public ServerHttpSecurity csrf(Customizer<CsrfSpec> csrfCustomizer) {
     if (this.csrf == null) {
       this.csrf = new CsrfSpec();
     }
     csrfCustomizer.customize(this.csrf);
     return this;
   }

    public final class CsrfSpec {

		private CsrfSpec() {
		}

        public ServerHttpSecurity disable() {
            ServerHttpSecurity.this.csrf = null;
            return ServerHttpSecurity.this;
          }
    }
}
