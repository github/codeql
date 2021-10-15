@Configuration(proxyBeanMethods = false)
public class SpringBootActuators extends WebSecurityConfigurerAdapter {

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    // BAD: Unauthenticated access to Spring Boot actuator endpoints is allowed
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests((requests) ->
        requests.anyRequest().permitAll());
  }
}

@Configuration(proxyBeanMethods = false)
public class ActuatorSecurity extends WebSecurityConfigurerAdapter {

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    // GOOD: only users with ENDPOINT_ADMIN role are allowed to access the actuator endpoints
    http.requestMatcher(EndpointRequest.toAnyEndpoint()).authorizeRequests((requests) ->
        requests.anyRequest().hasRole("ENDPOINT_ADMIN"));
    http.httpBasic();
  }
}