import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;

public class SpringCsrfProtectionTest {
    protected void test(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable()); // $ hasSpringCsrfProtectionDisabled
        http.csrf().disable(); // $ hasSpringCsrfProtectionDisabled
        http.csrf(AbstractHttpConfigurer::disable); // $ hasSpringCsrfProtectionDisabled
    }
}
