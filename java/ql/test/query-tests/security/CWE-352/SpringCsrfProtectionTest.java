import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.web.server.ServerHttpSecurity;

public class SpringCsrfProtectionTest {
    protected void test(HttpSecurity http, final ServerHttpSecurity httpSecurity) throws Exception {
        http.csrf(csrf -> csrf.disable()); // $ hasSpringCsrfProtectionDisabled
        http.csrf().disable(); // $ hasSpringCsrfProtectionDisabled
        http.csrf(AbstractHttpConfigurer::disable); // $ hasSpringCsrfProtectionDisabled

        httpSecurity.csrf(csrf -> csrf.disable()); // $ hasSpringCsrfProtectionDisabled
        httpSecurity.csrf().disable(); // $ hasSpringCsrfProtectionDisabled
        httpSecurity.csrf(ServerHttpSecurity.CsrfSpec::disable); // $ hasSpringCsrfProtectionDisabled
    }
}