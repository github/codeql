import static org.springframework.ldap.query.LdapQueryBuilder.query;
import org.springframework.ldap.support.LdapNameBuilder;

public void ldapQueryGood(@RequestParam String organizationName, @RequestParam String username) {
  // GOOD: Organization name is encoded before being used in DN
  String safeDn = LdapNameBuilder.newInstance()
    .add("O", organizationName)
    .add("OU=People")
    .build().toString();

  // GOOD: User input is encoded before being used in search filter
  LdapQuery query = query()
    .base(safeDn)
    .where("username").is(username);

  ldapTemplate.search(query, new AttributeCheckAttributesMapper());
}