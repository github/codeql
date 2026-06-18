import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.realm.ldap.LdapContextFactory;

public class LdapDnInjectionLibraryModeBad {
  private final LdapContextFactory ldapContextFactory;

  public LdapDnInjectionLibraryModeBad(LdapContextFactory ldapContextFactory) {
    this.ldapContextFactory = ldapContextFactory;
  }

  // BAD: the login principal is concatenated into the bind DN with no escaping, so an
  // attacker can supply DN metacharacters to manipulate the DN used to authenticate.
  protected String getUserDn(String principal) {
    return "uid=" + principal + ",ou=people,dc=example,dc=com";
  }

  public Object bind(AuthenticationToken token) throws Exception {
    String dn = getUserDn((String) token.getPrincipal());
    return ldapContextFactory.getLdapContext(dn, token.getCredentials());
  }
}
