import org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

public class SpringBootActuatorsTest {
  // Spring security version 5.2.3 used `authorizeRequests` and `requestMatcher(s)`
  protected void configure(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests(requests -> requests.anyRequest().permitAll()); // $ hasExposedSpringBootActuator
  }

  protected void configure2(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure3(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure4(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests().anyRequest().permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure5(HttpSecurity http) throws Exception {
    http.authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure6(HttpSecurity http) throws Exception {
    http.authorizeRequests(requests -> requests.requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll()); // $ hasExposedSpringBootActuator
  }

  protected void configure7(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeRequests().anyRequest().permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configureOk1(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOk2(HttpSecurity http) throws Exception {
    http.requestMatchers().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOk3(HttpSecurity http) throws Exception {
    http.authorizeRequests().anyRequest().permitAll();
  }

  protected void configureOk4(HttpSecurity http) throws Exception {
    http.authorizeRequests(authz -> authz.anyRequest().permitAll());
  }

  protected void configureOkSafeEndpoints1(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.to("health", "info")).authorizeRequests(requests -> requests.anyRequest().permitAll());
  }

  protected void configureOkSafeEndpoints2(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.to("health")).authorizeRequests().requestMatchers(EndpointRequest.to("health")).permitAll();
  }

  protected void configureOkSafeEndpoints3(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.to("health", "info")).authorizeRequests().requestMatchers(EndpointRequest.to("health", "info")).permitAll();
  }

  protected void configureOkSafeEndpoints4(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.to("health", "info")).authorizeRequests().anyRequest().permitAll();
  }

  protected void configureOkSafeEndpoints5(HttpSecurity http) throws Exception {
    http.authorizeRequests().requestMatchers(EndpointRequest.to("health", "info")).permitAll();
  }

  protected void configureOkSafeEndpoints6(HttpSecurity http) throws Exception {
    http.authorizeRequests(requests -> requests.requestMatchers(EndpointRequest.to("health", "info")).permitAll());
  }

  protected void configureOkSafeEndpoints7(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.to("health", "info")).authorizeRequests().anyRequest().permitAll();
  }

  protected void configureOkNoPermitAll1(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests(requests -> requests.anyRequest());
  }

  protected void configureOkNoPermitAll2(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll3(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll4(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests().anyRequest();
  }

  protected void configureOkNoPermitAll5(HttpSecurity http) throws Exception {
    http.authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll6(HttpSecurity http) throws Exception {
    http.authorizeRequests(requests -> requests.requestMatchers(EndpointRequest.toAnyEndpoint()));
  }

  protected void configureOkNoPermitAll7(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeRequests().anyRequest();
  }

  // Spring security version 5.5.0 introduced `authorizeHttpRequests`
  protected void configure_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests(requests -> requests.anyRequest().permitAll()); // $ hasExposedSpringBootActuator
  }

  protected void configure2_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure3_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure4_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest().permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure5_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure6_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(requests -> requests.requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll()); // $ hasExposedSpringBootActuator
  }

  protected void configure7_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest().permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configureOk3_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests().anyRequest().permitAll();
  }

  protected void configureOk4_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(authz -> authz.anyRequest().permitAll());
  }

  protected void configureOkSafeEndpoints1_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.to("health", "info")).authorizeHttpRequests(requests -> requests.anyRequest().permitAll());
  }

  protected void configureOkSafeEndpoints2_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.to("health")).authorizeHttpRequests().requestMatchers(EndpointRequest.to("health")).permitAll();
  }

  protected void configureOkSafeEndpoints3_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.to("health", "info")).authorizeHttpRequests().requestMatchers(EndpointRequest.to("health", "info")).permitAll();
  }

  protected void configureOkSafeEndpoints4_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.to("health", "info")).authorizeHttpRequests().anyRequest().permitAll();
  }

  protected void configureOkSafeEndpoints5_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests().requestMatchers(EndpointRequest.to("health", "info")).permitAll();
  }

  protected void configureOkSafeEndpoints6_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(requests -> requests.requestMatchers(EndpointRequest.to("health", "info")).permitAll());
  }

  protected void configureOkSafeEndpoints7_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.to("health", "info")).authorizeHttpRequests().anyRequest().permitAll();
  }

  protected void configureOkNoPermitAll1_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests(requests -> requests.anyRequest());
  }

  protected void configureOkNoPermitAll2_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll3_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll4_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest();
  }

  protected void configureOkNoPermitAll5_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll6_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests(requests -> requests.requestMatchers(EndpointRequest.toAnyEndpoint()));
  }

  protected void configureOkNoPermitAll7_authorizeHttpRequests(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest();
  }

  // Spring security version 5.8.0 introduced `securityMatcher(s)`
  protected void configure_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests(requests -> requests.anyRequest().permitAll()); // $ hasExposedSpringBootActuator
  }

  protected void configure2_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure3_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure4_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest().permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configure7_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest().permitAll(); // $ hasExposedSpringBootActuator
  }

  protected void configureOk1_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOk2_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatchers().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkSafeEndpoints1_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.to("health", "info")).authorizeHttpRequests(requests -> requests.anyRequest().permitAll());
  }

  protected void configureOkSafeEndpoints2_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.to("health")).authorizeHttpRequests().requestMatchers(EndpointRequest.to("health")).permitAll();
  }

  protected void configureOkSafeEndpoints3_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatchers(matcher -> EndpointRequest.to("health", "info")).authorizeHttpRequests().requestMatchers(EndpointRequest.to("health", "info")).permitAll();
  }

  protected void configureOkSafeEndpoints4_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.to("health", "info")).authorizeHttpRequests().anyRequest().permitAll();
  }

  protected void configureOkSafeEndpoints7_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatchers(matcher -> EndpointRequest.to("health", "info")).authorizeHttpRequests().anyRequest().permitAll();
  }

  protected void configureOkNoPermitAll1_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests(requests -> requests.anyRequest());
  }

  protected void configureOkNoPermitAll2_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll3_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().requestMatchers(EndpointRequest.toAnyEndpoint());
  }

  protected void configureOkNoPermitAll4_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatcher(EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest();
  }

  protected void configureOkNoPermitAll7_securityMatchers(HttpSecurity http) throws Exception {
    http.securityMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeHttpRequests().anyRequest();
  }

  // QHelp Bad example
  public void securityFilterChain1(HttpSecurity http) throws Exception {
    // BAD: Unauthenticated access to Spring Boot actuator endpoints is allowed
    http.securityMatcher(EndpointRequest.toAnyEndpoint());
    http.authorizeHttpRequests((requests) -> requests.anyRequest().permitAll()); // $ hasExposedSpringBootActuator
  }

  // QHelp Good example
  public void securityFilterChain2(HttpSecurity http) throws Exception {
    // GOOD: only users with ENDPOINT_ADMIN role are allowed to access the actuator endpoints
    http.securityMatcher(EndpointRequest.toAnyEndpoint());
    http.authorizeHttpRequests((requests) -> requests.anyRequest().hasRole("ENDPOINT_ADMIN"));
  }
}
