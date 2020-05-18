import org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

public class SpringBootActuators {
  protected void configure(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests(requests -> requests.anyRequest().permitAll());
  }

  protected void configure2(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll();
  }

  protected void configure3(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll();
  }

  protected void configure4(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests().anyRequest().permitAll();
  }

  protected void configure5(HttpSecurity http) throws Exception {
    http.authorizeRequests().requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll();
  }

  protected void configure6(HttpSecurity http) throws Exception {
    http.authorizeRequests(requests -> requests.requestMatchers(EndpointRequest.toAnyEndpoint()).permitAll());
  }

  protected void configure7(HttpSecurity http) throws Exception {
    http.requestMatchers(matcher -> EndpointRequest.toAnyEndpoint()).authorizeRequests().anyRequest().permitAll();
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
}
