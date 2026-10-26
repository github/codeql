@Configuration(proxyBeanMethods = false)
public class CustomSecurityConfiguration {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // BAD: Unauthenticated access to Spring Boot actuator endpoints is allowed
        http.securityMatcher(EndpointRequest.toAnyEndpoint());
        http.authorizeHttpRequests((requests) -> requests.anyRequest().permitAll());
        return http.build();
    }

}

@Configuration(proxyBeanMethods = false)
public class CustomSecurityConfiguration {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // GOOD: only users with ENDPOINT_ADMIN role are allowed to access the actuator endpoints
        http.securityMatcher(EndpointRequest.toAnyEndpoint());
        http.authorizeHttpRequests((requests) -> requests.anyRequest().hasRole("ENDPOINT_ADMIN"));
        return http.build();
    }

}
