import javax.naming.directory.DirContext;
import org.owasp.esapi.Encoder;
import org.owasp.esapi.reference.DefaultEncoder;

public void ldapQueryBad(HttpServletRequest request, DirContext ctx) throws NamingException {
  String organizationName = request.getParameter("organization_name");
  String username = request.getParameter("username");

  // BAD: User input used in DN (Distinguished Name) without encoding
  String dn = "OU=People,O=" + organizationName;

  // BAD: User input used in search filter without encoding
  String filter = "username=" + userName;

  ctx.search(dn, filter, new SearchControls());
}

public void ldapQueryGood(HttpServletRequest request, DirContext ctx) throws NamingException {
  String organizationName = request.getParameter("organization_name");
  String username = request.getParameter("username");

  // ESAPI encoder
  Encoder encoder = DefaultEncoder.getInstance();

  // GOOD: Organization name is encoded before being used in DN
  String safeOrganizationName = encoder.encodeForDN(organizationName);
  String safeDn = "OU=People,O=" + safeOrganizationName;

  // GOOD: User input is encoded before being used in search filter
  String safeUsername = encoder.encodeForLDAP(username);
  String safeFilter = "username=" + safeUsername;
  
  ctx.search(safeDn, safeFilter, new SearchControls());
}