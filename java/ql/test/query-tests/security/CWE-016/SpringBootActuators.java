import org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

public class ActuatorSecurityConfig {
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
}
