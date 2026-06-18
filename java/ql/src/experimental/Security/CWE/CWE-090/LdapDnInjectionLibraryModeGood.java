import javax.naming.ldap.Rdn;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.realm.ldap.LdapContextFactory;

public class LdapDnInjectionLibraryModeGood {
  private final LdapContextFactory ldapContextFactory;

  public LdapDnInjectionLibraryModeGood(LdapContextFactory ldapContextFactory) {
    this.ldapContextFactory = ldapContextFactory;
  }

  // GOOD: the login principal is escaped for RFC 2253 with Rdn.escapeValue before it
  // is placed in the DN, so DN metacharacters are neutralised.
  protected String getUserDn(String principal) {
    return "uid=" + Rdn.escapeValue(principal) + ",ou=people,dc=example,dc=com";
  }

  public Object bind(AuthenticationToken token) throws Exception {
    String dn = getUserDn((String) token.getPrincipal());
    return ldapContextFactory.getLdapContext(dn, token.getCredentials());
  }
}
