# LDAP query built from user-controlled sources

```
ID: java/ldap-injection
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-090

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-090/LdapInjection.ql)

If an LDAP query is built using string concatenation, and the components of the concatenation include user input, a user is likely to be able to run malicious LDAP queries.


## Recommendation
If user input must be included in an LDAP query, it should be escaped to avoid a malicious user providing special characters that change the meaning of the query. If possible build the LDAP query using framework helper methods, for example from Spring's `LdapQueryBuilder` and `LdapNameBuilder`, instead of string concatenation. Alternatively, escape user input using an appropriate LDAP encoding method, for example: `encodeForLDAP` or `encodeForDN` from OWASP ESAPI, `LdapEncoder.filterEncode` or `LdapEncoder.nameEncode` from Spring LDAP, or `Filter.encodeValue` from UnboundID library.


## Example
In the following examples, the code accepts an "organization name" and a "username" from the user, which it uses to query LDAP.

The first example concatenates the unvalidated and unencoded user input directly into both the DN (Distinguished Name) and the search filter used for the LDAP query. A malicious user could provide special characters to change the meaning of these queries, and search for a completely different set of values. The LDAP query is executed using Java JNDI API.

The second example uses the OWASP ESAPI library to encode the user values before they are included in the DN and search filters. This ensures the meaning of the query cannot be changed by a malicious user.


```java
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
```
The third example uses Spring `LdapQueryBuilder` to build an LDAP query. In addition to simplifying the building of complex search parameters, it also provides proper escaping of any unsafe characters in search filters. The DN is built using `LdapNameBuilder`, which also provides proper escaping.


```java
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
```
The fourth example uses `UnboundID` classes, `Filter` and `DN`, to construct a safe filter and base DN.


```java
import com.unboundid.ldap.sdk.LDAPConnection;
import com.unboundid.ldap.sdk.DN;
import com.unboundid.ldap.sdk.RDN;
import com.unboundid.ldap.sdk.Filter;

public void ldapQueryGood(HttpServletRequest request, LDAPConnection c) {
  String organizationName = request.getParameter("organization_name");
  String username = request.getParameter("username");

  // GOOD: Organization name is encoded before being used in DN
  DN safeDn = new DN(new RDN("OU", "People"), new RDN("O", organizationName));

  // GOOD: User input is encoded before being used in search filter
  Filter safeFilter = Filter.createEqualityFilter("username", username);
  
  c.search(safeDn.toString(), SearchScope.ONE, safeFilter);
}
```
The fifth example shows how to build a safe filter and DN using the Apache LDAP API.


```java
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
```

## References
* OWASP: [LDAP Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/LDAP_Injection_Prevention_Cheat_Sheet.html).
* OWASP ESAPI: [OWASP ESAPI](https://owasp.org/www-project-enterprise-security-api/).
* Spring LdapQueryBuilder doc: [LdapQueryBuilder](https://docs.spring.io/spring-ldap/docs/current/apidocs/org/springframework/ldap/query/LdapQueryBuilder.html).
* Spring LdapNameBuilder doc: [LdapNameBuilder](https://docs.spring.io/spring-ldap/docs/current/apidocs/org/springframework/ldap/support/LdapNameBuilder.html).
* UnboundID: [Understanding and Defending Against LDAP Injection Attacks](https://ldap.com/2018/05/04/understanding-and-defending-against-ldap-injection-attacks/).
* Common Weakness Enumeration: [CWE-90](https://cwe.mitre.org/data/definitions/90.html).