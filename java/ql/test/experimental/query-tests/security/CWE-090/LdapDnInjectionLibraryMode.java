// Fixture for java/ldap-dn-injection-library-mode. The login principal enters as a
// method parameter inside an authentication framework (no remote flow source), so the
// supported java/ldap-injection query has no source here. The library-mode query
// models the DN-builder parameter and the auth-token principal accessor as sources and
// the bind-DN positions as sinks. The shape mirrors Apache Shiro CVE-2026-49268.

import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.ldap.LdapContext;
import javax.naming.ldap.Rdn;

import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.realm.ldap.LdapContextFactory;

public class LdapDnInjectionLibraryMode {

  private String userDnPrefix = "uid=";
  private String userDnSuffix = ",ou=people,dc=example,dc=com";

  // ---- DN builders: the principal arrives as a String parameter (library-mode source) ----

  // BAD: principal concatenated straight into the bind DN, no escaping.
  protected String getUserDn(String principal) {
    return userDnPrefix + principal + userDnSuffix;
  }

  // GOOD: principal wrapped in Rdn.escapeValue (the canonical 2.2.1 fix).
  protected String getUserDnSafe(String principal) {
    return userDnPrefix + Rdn.escapeValue(principal) + userDnSuffix;
  }

  // BAD: ActiveDirectory-style "username with suffix" -- verbatim concatenation.
  protected String getUsernameWithSuffix(String username) {
    return username + "@example.com";
  }

  // ---- Sink: Context.SECURITY_PRINCIPAL environment value ----

  // BAD: tainted DN flows into the SECURITY_PRINCIPAL env value.
  public void bindBad(AuthenticationToken token) { // $ Source
    String dn = getUserDn((String) token.getPrincipal());
    Hashtable<String, Object> env = new Hashtable<String, Object>();
    env.put(Context.SECURITY_PRINCIPAL, dn); // $ Alert
  }

  // GOOD: same path but through the escaping builder.
  public void bindGood(AuthenticationToken token) {
    String dn = getUserDnSafe((String) token.getPrincipal());
    Hashtable<String, Object> env = new Hashtable<String, Object>();
    env.put(Context.SECURITY_PRINCIPAL, dn); // safe
  }

  // BAD: same sink using the literal property key and a UsernamePasswordToken.
  public void bindBadLiteralKey(UsernamePasswordToken token) { // $ Source
    String dn = getUserDn(token.getUsername());
    Hashtable<String, Object> env = new Hashtable<String, Object>();
    env.put("java.naming.security.principal", dn); // $ Alert
  }

  // ---- Sink: Shiro LdapContextFactory.getLdapContext(principal, credentials) ----

  // BAD: the exact CVE-2026-49268 sink -- tainted DN as the bind principal.
  public LdapContext queryBad(LdapContextFactory factory, AuthenticationToken token) // $ Source
      throws NamingException {
    String dn = getUsernameWithSuffix((String) token.getPrincipal());
    return factory.getLdapContext(dn, token.getCredentials()); // $ Alert
  }

  // GOOD: principal escaped before the bind.
  public LdapContext queryGood(LdapContextFactory factory, AuthenticationToken token)
      throws NamingException {
    String dn = userDnPrefix + Rdn.escapeValue(token.getPrincipal()) + userDnSuffix;
    return factory.getLdapContext(dn, token.getCredentials()); // safe
  }

  // ---- Sink: Context lookup with a String name ----

  // BAD: tainted DN used as a String name for a context lookup.
  public Object lookupBad(Context ctx, AuthenticationToken token) throws NamingException { // $ Source
    String dn = getUserDn((String) token.getPrincipal());
    return ctx.lookup(dn); // $ Alert
  }

  // GOOD: escaped before lookup.
  public Object lookupGood(Context ctx, AuthenticationToken token) throws NamingException {
    String dn = getUserDnSafe((String) token.getPrincipal());
    return ctx.lookup(dn); // safe
  }
}
