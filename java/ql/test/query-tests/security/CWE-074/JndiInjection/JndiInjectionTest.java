import java.io.IOException;
import java.util.Hashtable;
import java.util.Properties;

import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;
import javax.naming.CompositeName;
import javax.naming.CompoundName;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.Name;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.ldap.InitialLdapContext;

import org.springframework.jndi.JndiTemplate;
import org.springframework.ldap.core.AttributesMapper;
import org.springframework.ldap.core.ContextMapper;
import org.springframework.ldap.core.DirContextProcessor;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.core.NameClassPairCallbackHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class JndiInjectionTest {
  @RequestMapping
  public void testInitialContextBad1(@RequestParam String nameStr) throws NamingException { // $ Source
    Name name = new CompositeName(nameStr);
    InitialContext ctx = new InitialContext();

    ctx.lookup(nameStr); // $ Alert
    ctx.lookupLink(nameStr); // $ Alert
    InitialContext.doLookup(nameStr); // $ Alert
    ctx.rename(nameStr, ""); // $ Alert
    ctx.list(nameStr); // $ Alert
    ctx.listBindings(nameStr); // $ Alert

    ctx.lookup(name); // $ Alert
    ctx.lookupLink(name); // $ Alert
    InitialContext.doLookup(name); // $ Alert
    ctx.rename(name, null); // $ Alert
    ctx.list(name); // $ Alert
    ctx.listBindings(name); // $ Alert
  }

  @RequestMapping
  public void testDirContextBad1(@RequestParam String nameStr) throws NamingException { // $ Source
    Name name = new CompoundName(nameStr, new Properties());
    DirContext ctx = new InitialDirContext();

    ctx.lookup(nameStr); // $ Alert
    ctx.lookupLink(nameStr); // $ Alert
    ctx.rename(nameStr, ""); // $ Alert
    ctx.list(nameStr); // $ Alert
    ctx.listBindings(nameStr); // $ Alert

    ctx.lookup(name); // $ Alert
    ctx.lookupLink(name); // $ Alert
    ctx.rename(name, null); // $ Alert
    ctx.list(name); // $ Alert
    ctx.listBindings(name); // $ Alert

    SearchControls searchControls = new SearchControls();
    searchControls.setReturningObjFlag(true);
    ctx.search(nameStr, "", searchControls); // $ Alert
    ctx.search(nameStr, "", new Object[] {}, searchControls); // $ Alert

    SearchControls searchControls2 = new SearchControls(1, 0, 0, null, true, false);
    ctx.search(nameStr, "", searchControls2); // $ Alert
    ctx.search(nameStr, "", new Object[] {}, searchControls2); // $ Alert

    SearchControls searchControls3 = new SearchControls(1, 0, 0, null, false, false);
    ctx.search(nameStr, "", searchControls3); // Safe
    ctx.search(nameStr, "", new Object[] {}, searchControls3); // Safe
  }

  @RequestMapping
  public void testInitialLdapContextBad1(@RequestParam String nameStr) throws NamingException { // $ Source
    Name name = new CompositeName(nameStr);
    InitialLdapContext ctx = new InitialLdapContext();

    ctx.lookup(nameStr); // $ Alert
    ctx.lookupLink(nameStr); // $ Alert
    ctx.rename(nameStr, ""); // $ Alert
    ctx.list(nameStr); // $ Alert
    ctx.listBindings(nameStr); // $ Alert

    ctx.lookup(name); // $ Alert
    ctx.lookupLink(name); // $ Alert
    ctx.rename(name, null); // $ Alert
    ctx.list(name); // $ Alert
    ctx.listBindings(name); // $ Alert
  }

  @RequestMapping
  public void testSpringJndiTemplateBad1(@RequestParam String nameStr) throws NamingException { // $ Source
    JndiTemplate ctx = new JndiTemplate();

    ctx.lookup(nameStr); // $ Alert
    ctx.lookup(nameStr, null); // $ Alert
  }

  @RequestMapping
  public void testSpringLdapTemplateBad1(@RequestParam String nameStr) throws NamingException { // $ Source
    LdapTemplate ctx = new LdapTemplate();
    Name name = new CompositeName().add(nameStr);

    ctx.lookup(name); // $ Alert
    ctx.lookup(name, (AttributesMapper) null); // Safe
    ctx.lookup(name, (ContextMapper) null); // $ Alert
    ctx.lookup(name, new String[] {}, (AttributesMapper) null); // Safe
    ctx.lookup(name, new String[] {}, (ContextMapper) null); // $ Alert
    ctx.lookup(nameStr); // $ Alert
    ctx.lookup(nameStr, (AttributesMapper) null); // Safe
    ctx.lookup(nameStr, (ContextMapper) null); // $ Alert
    ctx.lookup(nameStr, new String[] {}, (AttributesMapper) null); // Safe
    ctx.lookup(nameStr, new String[] {}, (ContextMapper) null); // $ Alert
    ctx.lookupContext(name); // $ Alert
    ctx.lookupContext(nameStr); // $ Alert
    ctx.findByDn(name, null); // $ Alert
    ctx.rename(name, null); // $ Alert
    ctx.list(name); // $ Alert
    ctx.listBindings(name); // $ Alert
    ctx.unbind(nameStr, true); // $ Alert

    ctx.search(nameStr, "", 0, true, null); // $ Alert
    ctx.search(nameStr, "", 0, new String[] {}, (ContextMapper<Object>) null); // $ Alert
    ctx.search(nameStr, "", 0, (ContextMapper<Object>) null); // $ Alert
    ctx.search(nameStr, "", (ContextMapper<Object>) null); // $ Alert

    SearchControls searchControls = new SearchControls();
    searchControls.setReturningObjFlag(true);
    ctx.search(nameStr, "", searchControls, (AttributesMapper<Object>) null); // $ Alert
    ctx.search(nameStr, "", searchControls, (AttributesMapper<Object>) null, // $ Alert
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls, (ContextMapper<Object>) null); // $ Alert
    ctx.search(nameStr, "", searchControls, (ContextMapper<Object>) null, // $ Alert
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls, (NameClassPairCallbackHandler) null); // $ Alert
    ctx.search(nameStr, "", searchControls, (NameClassPairCallbackHandler) null, // $ Alert
        (DirContextProcessor) null);

    SearchControls searchControls2 = new SearchControls(1, 0, 0, null, true, false);
    ctx.search(nameStr, "", searchControls2, (AttributesMapper<Object>) null); // $ Alert
    ctx.search(nameStr, "", searchControls2, (AttributesMapper<Object>) null, // $ Alert
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls2, (ContextMapper<Object>) null); // $ Alert
    ctx.search(nameStr, "", searchControls2, (ContextMapper<Object>) null, // $ Alert
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls2, (NameClassPairCallbackHandler) null); // $ Alert
    ctx.search(nameStr, "", searchControls2, (NameClassPairCallbackHandler) null, // $ Alert
        (DirContextProcessor) null);

    SearchControls searchControls3 = new SearchControls(1, 0, 0, null, false, false);
    ctx.search(nameStr, "", searchControls3, (AttributesMapper<Object>) null); // Safe
    ctx.search(nameStr, "", searchControls3, (AttributesMapper<Object>) null, // Safe
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls3, (ContextMapper<Object>) null); // Safe
    ctx.search(nameStr, "", searchControls3, (ContextMapper<Object>) null, // Safe
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls3, (NameClassPairCallbackHandler) null); // Safe
    ctx.search(nameStr, "", searchControls3, (NameClassPairCallbackHandler) null, // Safe
        (DirContextProcessor) null);

    ctx.searchForObject(nameStr, "", (ContextMapper<Object>) null); // $ Alert
  }

  @RequestMapping
  public void testShiroJndiTemplateBad1(@RequestParam String nameStr) throws NamingException { // $ Source
    org.apache.shiro.jndi.JndiTemplate ctx = new org.apache.shiro.jndi.JndiTemplate();

    ctx.lookup(nameStr); // $ Alert
    ctx.lookup(nameStr, null); // $ Alert
  }

  @RequestMapping
  public void testJMXServiceUrlBad1(@RequestParam String urlStr) throws IOException { // $ Source
    JMXConnectorFactory.connect(new JMXServiceURL(urlStr)); // $ Alert

    JMXServiceURL url = new JMXServiceURL(urlStr);
    JMXConnector connector = JMXConnectorFactory.newJMXConnector(url, null);
    connector.connect(); // $ Alert
  }

  @RequestMapping
  public void testEnvBad1(@RequestParam String urlStr) throws NamingException { // $ Source
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put(Context.PROVIDER_URL, urlStr); // $ Alert
    new InitialContext(env);
  }

  @RequestMapping
  public void testEnvBad2(@RequestParam String urlStr) throws NamingException { // $ Source
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put("java.naming.provider.url", urlStr); // $ Alert
    new InitialDirContext(env);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad1(@RequestParam String urlStr) // $ Source
      throws NamingException {
    Properties props = new Properties();
    props.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.put(Context.PROVIDER_URL, urlStr); // $ Alert
    new JndiTemplate(props);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad2(@RequestParam String urlStr) // $ Source
      throws NamingException {
    Properties props = new Properties();
    props.setProperty(Context.INITIAL_CONTEXT_FACTORY,
        "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.setProperty("java.naming.provider.url", urlStr); // $ Alert
    new JndiTemplate(props);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad3(@RequestParam String urlStr) // $ Source
      throws NamingException {
    Properties props = new Properties();
    props.setProperty(Context.INITIAL_CONTEXT_FACTORY,
        "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.setProperty("java.naming.provider.url", urlStr); // $ Alert
    JndiTemplate template = new JndiTemplate();
    template.setEnvironment(props);
  }

  @RequestMapping
  public void testSpringLdapTemplateOk1(@RequestParam String nameStr) throws NamingException {
    LdapTemplate ctx = new LdapTemplate();

    ctx.unbind(nameStr); // Safe
    ctx.unbind(nameStr, false); // Safe

    ctx.search(nameStr, "", 0, false, null); // Safe
    ctx.search(nameStr, "", new SearchControls(), (NameClassPairCallbackHandler) new Object()); // Safe
    ctx.search(nameStr, "", new SearchControls(), (NameClassPairCallbackHandler) new Object(), // Safe
        null);
    ctx.search(nameStr, "", (NameClassPairCallbackHandler) new Object()); // Safe
    ctx.search(nameStr, "", 0, new String[] {}, (AttributesMapper<Object>) new Object()); // Safe
    ctx.search(nameStr, "", 0, (AttributesMapper<Object>) new Object()); // Safe
    ctx.search(nameStr, "", (AttributesMapper) new Object()); // Safe
    ctx.search(nameStr, "", new SearchControls(), (ContextMapper) new Object()); // Safe
    ctx.search(nameStr, "", new SearchControls(), (AttributesMapper) new Object()); // Safe
    ctx.search(nameStr, "", new SearchControls(), (ContextMapper) new Object(), null); // Safe
    ctx.search(nameStr, "", new SearchControls(), (AttributesMapper) new Object(), null); // Safe

    ctx.searchForObject(nameStr, "", new SearchControls(), (ContextMapper) new Object()); // Safe
  }

  @RequestMapping
  public void testEnvOk1(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put(Context.SECURITY_PRINCIPAL, urlStr); // Safe
    new InitialContext(env);
  }

  @RequestMapping
  public void testEnvOk2(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put("java.naming.security.principal", urlStr); // Safe
    new InitialContext(env);
  }
}
