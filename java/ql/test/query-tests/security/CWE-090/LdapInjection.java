import java.util.Hashtable;
import java.util.List;

import javax.naming.Context;
import javax.naming.Name;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import javax.naming.ldap.LdapName;
import javax.naming.ldap.Rdn;

import org.apache.shiro.realm.ldap.LdapContextFactory;

import com.unboundid.ldap.sdk.Filter;
import com.unboundid.ldap.sdk.LDAPConnection;
import com.unboundid.ldap.sdk.LDAPException;
import com.unboundid.ldap.sdk.LDAPSearchException;
import com.unboundid.ldap.sdk.ReadOnlySearchRequest;
import com.unboundid.ldap.sdk.SearchRequest;

import org.apache.directory.api.ldap.model.exception.LdapException;
import org.apache.directory.api.ldap.model.filter.EqualityNode;
import org.apache.directory.api.ldap.model.message.SearchRequestImpl;
import org.apache.directory.api.ldap.model.name.Dn;
import org.apache.directory.ldap.client.api.LdapConnection;
import org.apache.directory.ldap.client.api.LdapNetworkConnection;
import org.owasp.esapi.Encoder;
import org.owasp.esapi.reference.DefaultEncoder;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.filter.EqualsFilter;
import org.springframework.ldap.filter.HardcodedFilter;
import org.springframework.ldap.query.LdapQuery;
import org.springframework.ldap.query.LdapQueryBuilder;
import org.springframework.ldap.support.LdapEncoder;
import org.springframework.ldap.support.LdapNameBuilder;
import org.springframework.ldap.support.LdapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LdapInjection {
  // JNDI
  @RequestMapping
  public void testJndiBad1(@RequestParam String jBad, @RequestParam String jBadDN, DirContext ctx) // $ Source
      throws NamingException {
    ctx.search("ou=system" + jBadDN, "(uid=" + jBad + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiBad2(@RequestParam String jBad, @RequestParam String jBadDNName, InitialDirContext ctx) // $ Source
      throws NamingException {
    ctx.search(new LdapName("ou=system" + jBadDNName), "(uid=" + jBad + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiBad3(@RequestParam String jBad, @RequestParam String jOkDN, LdapContext ctx) // $ Source
      throws NamingException {
    ctx.search(new LdapName(List.of(new Rdn("ou=" + jOkDN))), "(uid=" + jBad + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiBad4(@RequestParam String jBadInitial, InitialLdapContext ctx) // $ Source
      throws NamingException {
    ctx.search("ou=system", "(uid=" + jBadInitial + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiBad5(@RequestParam String jBad, @RequestParam String jBadDNNameAdd, InitialDirContext ctx) // $ Source
      throws NamingException {
    ctx.search(new LdapName("").addAll(new LdapName("ou=system" + jBadDNNameAdd)), "(uid=" + jBad + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiBad6(@RequestParam String jBad, @RequestParam String jBadDNNameAdd2, InitialDirContext ctx) // $ Source
      throws NamingException {
    LdapName name = new LdapName("");
    name.addAll(new LdapName("ou=system" + jBadDNNameAdd2).getRdns());
    ctx.search(new LdapName("").addAll(name), "(uid=" + jBad + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiBad7(@RequestParam String jBad, @RequestParam String jBadDNNameToString, InitialDirContext ctx) // $ Source
      throws NamingException {
    ctx.search(new LdapName("ou=system" + jBadDNNameToString).toString(), "(uid=" + jBad + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiBad8(@RequestParam String jBad, @RequestParam String jBadDNNameClone, InitialDirContext ctx) // $ Source
      throws NamingException {
    ctx.search((Name) new LdapName("ou=system" + jBadDNNameClone).clone(), "(uid=" + jBad + ")", new SearchControls()); // $ Alert
  }

  @RequestMapping
  public void testJndiOk1(@RequestParam String jOkFilterExpr, DirContext ctx) throws NamingException {
    ctx.search("ou=system", "(uid={0})", new String[] { jOkFilterExpr }, new SearchControls());
  }

  @RequestMapping
  public void testJndiOk2(@RequestParam String jOkAttribute, DirContext ctx) throws NamingException { // $ Source
    ctx.search("ou=system", new BasicAttributes(jOkAttribute, jOkAttribute)); // $ Alert
  }

  // UnboundID
  @RequestMapping
  public void testUnboundBad1(@RequestParam String uBad, @RequestParam String uBadDN, LDAPConnection c) // $ Source
      throws LDAPSearchException {
    c.search(null, "ou=system" + uBadDN, null, null, 1, 1, false, "(uid=" + uBad + ")"); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad2(@RequestParam String uBadFilterCreate, LDAPConnection c) throws LDAPException { // $ Source
    c.search(null, "ou=system", null, null, 1, 1, false, Filter.create(uBadFilterCreate)); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad3(@RequestParam String uBadROSearchRequest, @RequestParam String uBadROSRDN, // $ Source
      LDAPConnection c) throws LDAPException {
    ReadOnlySearchRequest s = new SearchRequest(null, "ou=system" + uBadROSRDN, null, null, 1, 1, false,
        "(uid=" + uBadROSearchRequest + ")");
    c.search(s); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad4(@RequestParam String uBadSearchRequest, @RequestParam String uBadSRDN, LDAPConnection c) // $ Source
      throws LDAPException {
    SearchRequest s = new SearchRequest(null, "ou=system" + uBadSRDN, null, null, 1, 1, false,
        "(uid=" + uBadSearchRequest + ")");
    c.search(s); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad5(@RequestParam String uBad, @RequestParam String uBadDNSFR, LDAPConnection c) // $ Source
      throws LDAPSearchException {
    c.searchForEntry("ou=system" + uBadDNSFR, null, null, 1, false, "(uid=" + uBad + ")"); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad6(@RequestParam String uBadROSearchRequestAsync, @RequestParam String uBadROSRDNAsync, // $ Source
      LDAPConnection c) throws LDAPException {
    ReadOnlySearchRequest s = new SearchRequest(null, "ou=system" + uBadROSRDNAsync, null, null, 1, 1, false,
        "(uid=" + uBadROSearchRequestAsync + ")");
    c.asyncSearch(s); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad7(@RequestParam String uBadSearchRequestAsync, @RequestParam String uBadSRDNAsync, LDAPConnection c) // $ Source
      throws LDAPException {
    SearchRequest s = new SearchRequest(null, "ou=system" + uBadSRDNAsync, null, null, 1, 1, false,
        "(uid=" + uBadSearchRequestAsync + ")");
    c.asyncSearch(s); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad8(@RequestParam String uBadFilterCreateNOT, LDAPConnection c) throws LDAPException { // $ Source
    c.search(null, "ou=system", null, null, 1, 1, false, Filter.createNOTFilter(Filter.create(uBadFilterCreateNOT))); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad9(@RequestParam String uBadFilterCreateToString, LDAPConnection c) throws LDAPException { // $ Source
    c.search(null, "ou=system", null, null, 1, 1, false, Filter.create(uBadFilterCreateToString).toString()); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad10(@RequestParam String uBadFilterCreateToStringBuffer, LDAPConnection c) throws LDAPException { // $ Source
    StringBuilder b = new StringBuilder();
    Filter.create(uBadFilterCreateToStringBuffer).toNormalizedString(b);
    c.search(null, "ou=system", null, null, 1, 1, false, b.toString()); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad11(@RequestParam String uBadSearchRequestDuplicate, LDAPConnection c) // $ Source
      throws LDAPException {
    SearchRequest s = new SearchRequest(null, "ou=system", null, null, 1, 1, false,
        "(uid=" + uBadSearchRequestDuplicate + ")");
    c.search(s.duplicate()); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad12(@RequestParam String uBadROSearchRequestDuplicate, LDAPConnection c) // $ Source
      throws LDAPException {
    ReadOnlySearchRequest s = new SearchRequest(null, "ou=system", null, null, 1, 1, false,
        "(uid=" + uBadROSearchRequestDuplicate + ")");
    c.search(s.duplicate()); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad13(@RequestParam String uBadSearchRequestSetDN, LDAPConnection c) // $ Source
      throws LDAPException {
    SearchRequest s = new SearchRequest(null, "", null, null, 1, 1, false, "");
    s.setBaseDN(uBadSearchRequestSetDN);
    c.search(s); // $ Alert
  }

  @RequestMapping
  public void testUnboundBad14(@RequestParam String uBadSearchRequestSetFilter, LDAPConnection c) // $ Source
      throws LDAPException {
    SearchRequest s = new SearchRequest(null, "ou=system", null, null, 1, 1, false, "");
    s.setFilter(uBadSearchRequestSetFilter);
    c.search(s); // $ Alert
  }

  @RequestMapping
  public void testUnboundOk1(@RequestParam String uOkEqualityFilter, LDAPConnection c) throws LDAPSearchException {
    c.search(null, "ou=system", null, null, 1, 1, false, Filter.createEqualityFilter("uid", uOkEqualityFilter));
  }

  @RequestMapping
  public void testUnboundOk2(@RequestParam String uOkVaragsAttr, LDAPConnection c) throws LDAPSearchException {
    c.search("ou=system", null, null, 1, 1, false, "(uid=fixed)", "a" + uOkVaragsAttr);
  }

  @RequestMapping
  public void testUnboundOk3(@RequestParam String uOkFilterSearchRequest, LDAPConnection c) throws LDAPException {
    SearchRequest s = new SearchRequest(null, "ou=system", null, null, 1, 1, false,
        Filter.createEqualityFilter("uid", uOkFilterSearchRequest));
    c.search(s);
  }

  @RequestMapping
  public void testUnboundOk4(@RequestParam String uOkSearchRequestVarargs, LDAPConnection c) throws LDAPException {
    SearchRequest s = new SearchRequest("ou=system", null, "(uid=fixed)", "va1", "va2", "va3",
        "a" + uOkSearchRequestVarargs);
    c.search(s);
  }

  // Spring LDAP
  @RequestMapping
  public void testSpringBad1(@RequestParam String sBad, @RequestParam String sBadDN, LdapTemplate c) { // $ Source
    c.search("ou=system" + sBadDN, "(uid=" + sBad + ")", 1, false, null); // $ Alert
  }

  @RequestMapping
  public void testSpringBad2(@RequestParam String sBad, @RequestParam String sBadDNLNBuilder, LdapTemplate c) { // $ Source
    c.authenticate(LdapNameBuilder.newInstance("ou=system" + sBadDNLNBuilder).build(), "(uid=" + sBad + ")", "pass"); // $ Alert
  }

  @RequestMapping
  public void testSpringBad3(@RequestParam String sBad, @RequestParam String sBadDNLNBuilderAdd, LdapTemplate c) { // $ Source
    c.searchForObject(LdapNameBuilder.newInstance().add("ou=system" + sBadDNLNBuilderAdd).build(), "(uid=" + sBad + ")", null); // $ Alert
  }

  @RequestMapping
  public void testSpringBad4(@RequestParam String sBadLdapQuery, LdapTemplate c) { // $ Source
    c.findOne(LdapQueryBuilder.query().filter("(uid=" + sBadLdapQuery + ")"), null); // $ Alert
  }

  @RequestMapping
  public void testSpringBad5(@RequestParam String sBadFilter, @RequestParam String sBadDNLdapUtils, LdapTemplate c) { // $ Source
    c.find(LdapUtils.newLdapName("ou=system" + sBadDNLdapUtils), new HardcodedFilter("(uid=" + sBadFilter + ")"), null, null); // $ Alert
  }

  @RequestMapping
  public void testSpringBad6(@RequestParam String sBadLdapQuery, LdapTemplate c) { // $ Source
    c.searchForContext(LdapQueryBuilder.query().filter("(uid=" + sBadLdapQuery + ")")); // $ Alert
  }

  @RequestMapping
  public void testSpringBad7(@RequestParam String sBadLdapQuery2, LdapTemplate c) { // $ Source
    LdapQuery q = LdapQueryBuilder.query().filter("(uid=" + sBadLdapQuery2 + ")");
    c.searchForContext(q); // $ Alert
  }

  @RequestMapping
  public void testSpringBad8(@RequestParam String sBadLdapQueryWithFilter, LdapTemplate c) { // $ Source
    c.searchForContext(LdapQueryBuilder.query().filter(new HardcodedFilter("(uid=" + sBadLdapQueryWithFilter + ")"))); // $ Alert
  }

  @RequestMapping
  public void testSpringBad9(@RequestParam String sBadLdapQueryWithFilter2, LdapTemplate c) { // $ Source
    org.springframework.ldap.filter.Filter f = new HardcodedFilter("(uid=" + sBadLdapQueryWithFilter2 + ")");
    c.searchForContext(LdapQueryBuilder.query().filter(f)); // $ Alert
  }

  @RequestMapping
  public void testSpringBad10(@RequestParam String sBadLdapQueryBase, LdapTemplate c) { // $ Source
    c.find(LdapQueryBuilder.query().base(sBadLdapQueryBase).base(), null, null, null); // $ Alert
  }

  @RequestMapping
  public void testSpringBad11(@RequestParam String sBadLdapQueryComplex, LdapTemplate c) { // $ Source
    c.searchForContext(LdapQueryBuilder.query().base(sBadLdapQueryComplex).where("uid").is("test")); // $ Alert
  }

  @RequestMapping
  public void testSpringBad12(@RequestParam String sBadFilterToString, LdapTemplate c) { // $ Source
    c.search("", new HardcodedFilter("(uid=" + sBadFilterToString + ")").toString(), 1, false, null); // $ Alert
  }

  @RequestMapping
  public void testSpringBad13(@RequestParam String sBadFilterEncode, LdapTemplate c) { // $ Source
    StringBuffer s = new StringBuffer();
    new HardcodedFilter("(uid=" + sBadFilterEncode + ")").encode(s);
    c.search("", s.toString(), 1, false, null); // $ Alert
  }

  @RequestMapping
  public void testSpringOk1(@RequestParam String sOkLdapQuery, LdapTemplate c) {
    c.find(LdapQueryBuilder.query().filter("(uid={0})", sOkLdapQuery), null);
  }

  @RequestMapping
  public void testSpringOk2(@RequestParam String sOkFilter, @RequestParam String sOkDN, LdapTemplate c) {
    c.find(LdapNameBuilder.newInstance().add("ou", sOkDN).build(), new EqualsFilter("uid", sOkFilter), null, null);
  }

  @RequestMapping
  public void testSpringOk3(@RequestParam String sOkLdapQuery, @RequestParam String sOkPassword, LdapTemplate c) {
    c.authenticate(LdapQueryBuilder.query().filter("(uid={0})", sOkLdapQuery), sOkPassword);
  }

  // Apache LDAP API
  @RequestMapping
  public void testApacheBad1(@RequestParam String aBad, @RequestParam String aBadDN, LdapConnection c) // $ Source
      throws LdapException {
    c.search("ou=system" + aBadDN, "(uid=" + aBad + ")", null); // $ Alert
  }

  @RequestMapping
  public void testApacheBad2(@RequestParam String aBad, @RequestParam String aBadDNObjToString, LdapNetworkConnection c) // $ Source
      throws LdapException {
    c.search(new Dn("ou=system" + aBadDNObjToString).getName(), "(uid=" + aBad + ")", null); // $ Alert
  }

  @RequestMapping
  public void testApacheBad3(@RequestParam String aBadSearchRequest, LdapConnection c) // $ Source
      throws LdapException {
    org.apache.directory.api.ldap.model.message.SearchRequest s = new SearchRequestImpl();
    s.setFilter("(uid=" + aBadSearchRequest + ")");
    c.search(s); // $ Alert
  }

  @RequestMapping
  public void testApacheBad4(@RequestParam String aBadSearchRequestImpl, @RequestParam String aBadDNObj, LdapConnection c) // $ Source
      throws LdapException {
    SearchRequestImpl s = new SearchRequestImpl();
    s.setBase(new Dn("ou=system" + aBadDNObj));
    c.search(s); // $ Alert
  }

  @RequestMapping
  public void testApacheBad5(@RequestParam String aBadDNSearchRequestGet, LdapConnection c) // $ Source
      throws LdapException {
    org.apache.directory.api.ldap.model.message.SearchRequest s = new SearchRequestImpl();
    s.setBase(new Dn("ou=system" + aBadDNSearchRequestGet));
    c.search(s.getBase(), "(uid=test", null); // $ Alert
  }

  @RequestMapping
  public void testApacheOk1(@RequestParam String aOk, LdapConnection c)
      throws LdapException {
    org.apache.directory.api.ldap.model.message.SearchRequest s = new SearchRequestImpl();
    s.setFilter(new EqualityNode<String>("uid", aOk));
    c.search(s);
  }

  @RequestMapping
  public void testApacheOk2(@RequestParam String aOk, LdapConnection c)
      throws LdapException {
    SearchRequestImpl s = new SearchRequestImpl();
    s.setFilter(new EqualityNode<String>("uid", aOk));
    c.search(s);
  }

  // ESAPI encoder sanitizer
  @RequestMapping
  public void testOk3(@RequestParam String okEncodeForLDAP, DirContext ctx) throws NamingException {
    Encoder encoder = DefaultEncoder.getInstance();
    ctx.search("ou=system", "(uid=" + encoder.encodeForLDAP(okEncodeForLDAP) + ")", new SearchControls());
  }

  // Spring LdapEncoder sanitizer
  @RequestMapping
  public void testOk4(@RequestParam String okFilterEncode, DirContext ctx) throws NamingException {
    ctx.search("ou=system", "(uid=" + LdapEncoder.filterEncode(okFilterEncode) + ")", new SearchControls());
  }

  // UnboundID Filter.encodeValue sanitizer
  @RequestMapping
  public void testOk5(@RequestParam String okUnboundEncodeValue, DirContext ctx) throws NamingException {
    ctx.search("ou=system", "(uid=" + Filter.encodeValue(okUnboundEncodeValue) + ")", new SearchControls());
  }

  // Bind DN injection (CWE-90, RFC 2253). The DN escape set differs from the search
  // filter escape set, so a DN sink needs a DN escaper (Rdn.escapeValue); a filter
  // escaper (e.g. LdapEncoder.filterEncode) does NOT sanitize a DN.

  // Context.SECURITY_PRINCIPAL environment value (the bind DN).
  @RequestMapping
  public void testBindDnBad1(@RequestParam String bBadPrincipal) // $ Source
      throws NamingException {
    Hashtable<String, Object> env = new Hashtable<String, Object>();
    env.put(Context.SECURITY_PRINCIPAL, "uid=" + bBadPrincipal + ",ou=people,dc=example,dc=com"); // $ Alert
    new InitialDirContext(env);
  }

  // Same sink via the literal property key.
  @RequestMapping
  public void testBindDnBad2(@RequestParam String bBadPrincipalLiteral) // $ Source
      throws NamingException {
    Hashtable<String, Object> env = new Hashtable<String, Object>();
    env.put("java.naming.security.principal", "uid=" + bBadPrincipalLiteral + ",dc=example,dc=com"); // $ Alert
    new InitialDirContext(env);
  }

  // DirContext.bind name argument is interpreted as a DN.
  @RequestMapping
  public void testBindDnBad3(@RequestParam String bBadBind, DirContext ctx) // $ Source
      throws NamingException {
    ctx.bind("uid=" + bBadBind + ",ou=people", null, new BasicAttributes()); // $ Alert
  }

  // Context.lookup name argument is interpreted as a DN (also a jndi-injection sink).
  @RequestMapping
  public void testBindDnBad4(@RequestParam String bBadLookup, Context ctx) // $ Source
      throws NamingException {
    ctx.lookup("uid=" + bBadLookup + ",ou=people"); // $ Alert
  }

  // Shiro LdapContextFactory.getLdapContext principal argument (CVE-2026-49268 sink).
  @RequestMapping
  public LdapContext testBindDnBad5(@RequestParam String bBadShiro, LdapContextFactory factory) // $ Source
      throws NamingException {
    return factory.getLdapContext("uid=" + bBadShiro + ",ou=people", "secret"); // $ Alert
  }

  // GOOD: the principal is escaped with Rdn.escapeValue (the canonical 2.2.1 fix).
  @RequestMapping
  public void testBindDnOk1(@RequestParam String bOkPrincipal) throws NamingException {
    Hashtable<String, Object> env = new Hashtable<String, Object>();
    env.put(Context.SECURITY_PRINCIPAL,
        "uid=" + Rdn.escapeValue(bOkPrincipal) + ",ou=people,dc=example,dc=com"); // safe
    new InitialDirContext(env);
  }

  // GOOD: bind DN escaped with Rdn.escapeValue.
  @RequestMapping
  public void testBindDnOk2(@RequestParam String bOkBind, DirContext ctx) throws NamingException {
    ctx.bind("uid=" + Rdn.escapeValue(bOkBind) + ",ou=people", null, new BasicAttributes()); // safe
  }
}
