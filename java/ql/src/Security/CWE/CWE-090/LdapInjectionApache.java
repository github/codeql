import org.apache.directory.ldap.client.api.LdapConnection;
import org.apache.directory.api.ldap.model.name.Dn;
import org.apache.directory.api.ldap.model.name.Rdn;
import org.apache.directory.api.ldap.model.message.SearchRequest;
import org.apache.directory.api.ldap.model.message.SearchRequestImpl;
import static org.apache.directory.ldap.client.api.search.FilterBuilder.equal;

public void ldapQueryGood(HttpServletRequest request, LdapConnection c) {
  String organizationName = request.getParameter("organization_name");
  String username = request.getParameter("username");

  // GOOD: Organization name is encoded before being used in DN
  Dn safeDn = new Dn(new Rdn("OU", "People"), new Rdn("O", organizationName));

  // GOOD: User input is encoded before being used in search filter
  String safeFilter = equal("username", username);
  
  SearchRequest searchRequest = new SearchRequestImpl();
  searchRequest.setBase(safeDn);
  searchRequest.setFilter(safeFilter);
  c.search(searchRequest);
}