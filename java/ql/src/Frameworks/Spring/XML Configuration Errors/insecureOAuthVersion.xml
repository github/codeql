import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.provider.endpoint.AuthorizationEndpoint;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class AuthorizationEndpointConfigurer {

    @Autowired
    private AuthorizationEndpoint authorizationEndpoint;

    @PostConstruct
    public void init() {
      //BAD: if spring security oauth version is old, RCE attack can be used.
      authorizationEndpoint.setUserApprovalPage("forward:/oauth/confirm_access");
    }
}