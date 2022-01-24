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
  public void testInitialContextBad1(@RequestParam String nameStr) throws NamingException {
    Name name = new CompositeName(nameStr);
    InitialContext ctx = new InitialContext();

    ctx.lookup(nameStr); // $hasJndiInjection
    ctx.lookupLink(nameStr); // $hasJndiInjection
    InitialContext.doLookup(nameStr); // $hasJndiInjection
    ctx.rename(nameStr, ""); // $hasJndiInjection
    ctx.list(nameStr); // $hasJndiInjection
    ctx.listBindings(nameStr); // $hasJndiInjection

    ctx.lookup(name); // $hasJndiInjection
    ctx.lookupLink(name); // $hasJndiInjection
    InitialContext.doLookup(name); // $hasJndiInjection
    ctx.rename(name, null); // $hasJndiInjection
    ctx.list(name); // $hasJndiInjection
    ctx.listBindings(name); // $hasJndiInjection
  }

  @RequestMapping
  public void testDirContextBad1(@RequestParam String nameStr) throws NamingException {
    Name name = new CompoundName(nameStr, new Properties());
    DirContext ctx = new InitialDirContext();

    ctx.lookup(nameStr); // $hasJndiInjection
    ctx.lookupLink(nameStr); // $hasJndiInjection
    ctx.rename(nameStr, ""); // $hasJndiInjection
    ctx.list(nameStr); // $hasJndiInjection
    ctx.listBindings(nameStr); // $hasJndiInjection

    ctx.lookup(name); // $hasJndiInjection
    ctx.lookupLink(name); // $hasJndiInjection
    ctx.rename(name, null); // $hasJndiInjection
    ctx.list(name); // $hasJndiInjection
    ctx.listBindings(name); // $hasJndiInjection

    SearchControls searchControls = new SearchControls();
    searchControls.setReturningObjFlag(true);
    ctx.search(nameStr, "", searchControls); // $hasJndiInjection
    ctx.search(nameStr, "", new Object[] {}, searchControls); // $hasJndiInjection

    SearchControls searchControls2 = new SearchControls(1, 0, 0, null, true, false);
    ctx.search(nameStr, "", searchControls2); // $hasJndiInjection
    ctx.search(nameStr, "", new Object[] {}, searchControls2); // $hasJndiInjection

    SearchControls searchControls3 = new SearchControls(1, 0, 0, null, false, false);
    ctx.search(nameStr, "", searchControls3); // Safe
    ctx.search(nameStr, "", new Object[] {}, searchControls3); // Safe
  }

  @RequestMapping
  public void testInitialLdapContextBad1(@RequestParam String nameStr) throws NamingException {
    Name name = new CompositeName(nameStr);
    InitialLdapContext ctx = new InitialLdapContext();

    ctx.lookup(nameStr); // $hasJndiInjection
    ctx.lookupLink(nameStr); // $hasJndiInjection
    ctx.rename(nameStr, ""); // $hasJndiInjection
    ctx.list(nameStr); // $hasJndiInjection
    ctx.listBindings(nameStr); // $hasJndiInjection

    ctx.lookup(name); // $hasJndiInjection
    ctx.lookupLink(name); // $hasJndiInjection
    ctx.rename(name, null); // $hasJndiInjection
    ctx.list(name); // $hasJndiInjection
    ctx.listBindings(name); // $hasJndiInjection
  }

  @RequestMapping
  public void testSpringJndiTemplateBad1(@RequestParam String nameStr) throws NamingException {
    JndiTemplate ctx = new JndiTemplate();

    ctx.lookup(nameStr); // $hasJndiInjection
    ctx.lookup(nameStr, null); // $hasJndiInjection
  }

  @RequestMapping
  public void testSpringLdapTemplateBad1(@RequestParam String nameStr) throws NamingException {
    LdapTemplate ctx = new LdapTemplate();
    Name name = new CompositeName().add(nameStr);

    ctx.lookup(name); // $hasJndiInjection
    ctx.lookup(name, (AttributesMapper) null); // Safe
    ctx.lookup(name, (ContextMapper) null); // $hasJndiInjection
    ctx.lookup(name, new String[] {}, (AttributesMapper) null); // Safe
    ctx.lookup(name, new String[] {}, (ContextMapper) null); // $hasJndiInjection
    ctx.lookup(nameStr); // $hasJndiInjection
    ctx.lookup(nameStr, (AttributesMapper) null); // Safe
    ctx.lookup(nameStr, (ContextMapper) null); // $hasJndiInjection
    ctx.lookup(nameStr, new String[] {}, (AttributesMapper) null); // Safe
    ctx.lookup(nameStr, new String[] {}, (ContextMapper) null); // $hasJndiInjection
    ctx.lookupContext(name); // $hasJndiInjection
    ctx.lookupContext(nameStr); // $hasJndiInjection
    ctx.findByDn(name, null); // $hasJndiInjection
    ctx.rename(name, null); // $hasJndiInjection
    ctx.list(name); // $hasJndiInjection
    ctx.listBindings(name); // $hasJndiInjection
    ctx.unbind(nameStr, true); // $hasJndiInjection

    ctx.search(nameStr, "", 0, true, null); // $hasJndiInjection
    ctx.search(nameStr, "", 0, new String[] {}, (ContextMapper<Object>) null); // $hasJndiInjection
    ctx.search(nameStr, "", 0, (ContextMapper<Object>) null); // $hasJndiInjection
    ctx.search(nameStr, "", (ContextMapper<Object>) null); // $hasJndiInjection

    SearchControls searchControls = new SearchControls();
    searchControls.setReturningObjFlag(true);
    ctx.search(nameStr, "", searchControls, (AttributesMapper<Object>) null); // $hasJndiInjection
    ctx.search(nameStr, "", searchControls, (AttributesMapper<Object>) null, // $hasJndiInjection
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls, (ContextMapper<Object>) null); // $hasJndiInjection
    ctx.search(nameStr, "", searchControls, (ContextMapper<Object>) null, // $hasJndiInjection
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls, (NameClassPairCallbackHandler) null); // $hasJndiInjection
    ctx.search(nameStr, "", searchControls, (NameClassPairCallbackHandler) null, // $hasJndiInjection
        (DirContextProcessor) null);

    SearchControls searchControls2 = new SearchControls(1, 0, 0, null, true, false);
    ctx.search(nameStr, "", searchControls2, (AttributesMapper<Object>) null); // $hasJndiInjection
    ctx.search(nameStr, "", searchControls2, (AttributesMapper<Object>) null, // $hasJndiInjection
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls2, (ContextMapper<Object>) null); // $hasJndiInjection
    ctx.search(nameStr, "", searchControls2, (ContextMapper<Object>) null, // $hasJndiInjection
        (DirContextProcessor) null);
    ctx.search(nameStr, "", searchControls2, (NameClassPairCallbackHandler) null); // $hasJndiInjection
    ctx.search(nameStr, "", searchControls2, (NameClassPairCallbackHandler) null, // $hasJndiInjection
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

    ctx.searchForObject(nameStr, "", (ContextMapper<Object>) null); // $hasJndiInjection
  }

  @RequestMapping
  public void testShiroJndiTemplateBad1(@RequestParam String nameStr) throws NamingException {
    org.apache.shiro.jndi.JndiTemplate ctx = new org.apache.shiro.jndi.JndiTemplate();

    ctx.lookup(nameStr); // $hasJndiInjection
    ctx.lookup(nameStr, null); // $hasJndiInjection
  }

  @RequestMapping
  public void testJMXServiceUrlBad1(@RequestParam String urlStr) throws IOException {
    JMXConnectorFactory.connect(new JMXServiceURL(urlStr)); // $hasJndiInjection

    JMXServiceURL url = new JMXServiceURL(urlStr);
    JMXConnector connector = JMXConnectorFactory.newJMXConnector(url, null);
    connector.connect(); // $hasJndiInjection
  }

  @RequestMapping
  public void testEnvBad1(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put(Context.PROVIDER_URL, urlStr); // $hasJndiInjection
    new InitialContext(env);
  }

  @RequestMapping
  public void testEnvBad2(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put("java.naming.provider.url", urlStr); // $hasJndiInjection
    new InitialDirContext(env);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad1(@RequestParam String urlStr)
      throws NamingException {
    Properties props = new Properties();
    props.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.put(Context.PROVIDER_URL, urlStr); // $hasJndiInjection
    new JndiTemplate(props);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad2(@RequestParam String urlStr)
      throws NamingException {
    Properties props = new Properties();
    props.setProperty(Context.INITIAL_CONTEXT_FACTORY,
        "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.setProperty("java.naming.provider.url", urlStr); // $hasJndiInjection
    new JndiTemplate(props);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad3(@RequestParam String urlStr)
      throws NamingException {
    Properties props = new Properties();
    props.setProperty(Context.INITIAL_CONTEXT_FACTORY,
        "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.setProperty("java.naming.provider.url", urlStr); // $hasJndiInjection
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
