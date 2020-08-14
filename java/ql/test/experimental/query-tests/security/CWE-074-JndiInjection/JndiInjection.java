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
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.ldap.InitialLdapContext;

import org.springframework.jndi.JndiTemplate;
import org.springframework.ldap.core.AttributesMapper;
import org.springframework.ldap.core.ContextMapper;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.core.NameClassPairCallbackHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class JndiInjection {
  @RequestMapping
  public void testInitialContextBad1(@RequestParam String nameStr) throws NamingException {
    Name name = new CompositeName(nameStr);
    InitialContext ctx = new InitialContext();

    ctx.lookup(nameStr);
    ctx.lookupLink(nameStr);
    InitialContext.doLookup(nameStr);
    ctx.rename(nameStr, "");
    ctx.list(nameStr);
    ctx.listBindings(nameStr);

    ctx.lookup(name);
    ctx.lookupLink(name);
    InitialContext.doLookup(name);
    ctx.rename(name, null);
    ctx.list(name);
    ctx.listBindings(name);
  }

  @RequestMapping
  public void testInitialDirContextBad1(@RequestParam String nameStr) throws NamingException {
    Name name = new CompoundName(nameStr, new Properties());
    InitialDirContext ctx = new InitialDirContext();

    ctx.lookup(nameStr);
    ctx.lookupLink(nameStr);
    ctx.rename(nameStr, "");
    ctx.list(nameStr);
    ctx.listBindings(nameStr);

    ctx.lookup(name);
    ctx.lookupLink(name);
    ctx.rename(name, null);
    ctx.list(name);
    ctx.listBindings(name);
  }

  @RequestMapping
  public void testInitialLdapContextBad1(@RequestParam String nameStr) throws NamingException {
    Name name = new CompositeName(nameStr);
    InitialLdapContext ctx = new InitialLdapContext();

    ctx.lookup(nameStr);
    ctx.lookupLink(nameStr);
    ctx.rename(nameStr, "");
    ctx.list(nameStr);
    ctx.listBindings(nameStr);

    ctx.lookup(name);
    ctx.lookupLink(name);
    ctx.rename(name, null);
    ctx.list(name);
    ctx.listBindings(name);
  }

  @RequestMapping
  public void testSpringJndiTemplateBad1(@RequestParam String nameStr) throws NamingException {
    JndiTemplate ctx = new JndiTemplate();

    ctx.lookup(nameStr);
    ctx.lookup(nameStr, null);
  }

  @RequestMapping
  public void testSpringLdapTemplateBad1(@RequestParam String nameStr) throws NamingException {
    LdapTemplate ctx = new LdapTemplate();
    Name name = new CompositeName(nameStr);

    ctx.lookup(nameStr);
    ctx.lookupContext(nameStr);
    ctx.findByDn(name, null);
    ctx.rename(name, null);
    ctx.list(name);
    ctx.listBindings(name);
    ctx.unbind(nameStr, true);

    ctx.search(nameStr, "", 0, true, null);
    ctx.search(nameStr, "", 0, new String[] {}, (ContextMapper<Object>) new Object());
    ctx.search(nameStr, "", 0, (ContextMapper<Object>) new Object());
    ctx.search(nameStr, "", (ContextMapper) new Object());
    
    ctx.searchForObject(nameStr, "", (ContextMapper) new Object());
  }

  @RequestMapping
  public void testShiroJndiTemplateBad1(@RequestParam String nameStr) throws NamingException {
    org.apache.shiro.jndi.JndiTemplate ctx = new org.apache.shiro.jndi.JndiTemplate();

    ctx.lookup(nameStr);
    ctx.lookup(nameStr, null);
  }

  @RequestMapping
  public void testJMXServiceUrlBad1(@RequestParam String urlStr) throws IOException {
    JMXConnectorFactory.connect(new JMXServiceURL(urlStr));

    JMXServiceURL url = new JMXServiceURL(urlStr);
    JMXConnector connector = JMXConnectorFactory.newJMXConnector(url, null);
    connector.connect();
  }

  @RequestMapping
  public void testEnvBad1(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put(Context.PROVIDER_URL, urlStr);
    new InitialContext(env);
  }

  @RequestMapping
  public void testEnvBad2(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put("java.naming.provider.url", urlStr);
    new InitialDirContext(env);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad1(@RequestParam String urlStr) throws NamingException {
    Properties props = new Properties();
    props.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.put(Context.PROVIDER_URL, urlStr);
    new JndiTemplate(props);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad2(@RequestParam String urlStr) throws NamingException {
    Properties props = new Properties();
    props.setProperty(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.setProperty("java.naming.provider.url", urlStr);
    new JndiTemplate(props);
  }

  @RequestMapping
  public void testSpringJndiTemplatePropertiesBad3(@RequestParam String urlStr) throws NamingException {
    Properties props = new Properties();
    props.setProperty(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    props.setProperty("java.naming.provider.url", urlStr);
    JndiTemplate template = new JndiTemplate();
    template.setEnvironment(props);
  }

  @RequestMapping
  public void testSpringLdapTemplateOk1(@RequestParam String nameStr) throws NamingException {
    LdapTemplate ctx = new LdapTemplate();

    ctx.unbind(nameStr);
    ctx.unbind(nameStr, false);

    ctx.search(nameStr, "", 0, false, null);
    ctx.search(nameStr, "", new SearchControls(), (NameClassPairCallbackHandler) new Object());
    ctx.search(nameStr, "", new SearchControls(), (NameClassPairCallbackHandler) new Object(), null);
    ctx.search(nameStr, "", (NameClassPairCallbackHandler) new Object());
    ctx.search(nameStr, "", 0, new String[] {}, (AttributesMapper<Object>) new Object());
    ctx.search(nameStr, "", 0, (AttributesMapper<Object>) new Object());
    ctx.search(nameStr, "", (AttributesMapper) new Object());
    ctx.search(nameStr, "", new SearchControls(), (ContextMapper) new Object());
    ctx.search(nameStr, "", new SearchControls(), (AttributesMapper) new Object());
    ctx.search(nameStr, "", new SearchControls(), (ContextMapper) new Object(), null);
    ctx.search(nameStr, "", new SearchControls(), (AttributesMapper) new Object(), null);

    ctx.searchForObject(nameStr, "", new SearchControls(), (ContextMapper) new Object());
  }

  @RequestMapping
  public void testEnvOk1(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put(Context.SECURITY_PRINCIPAL, urlStr);
    new InitialContext(env);
  }

  @RequestMapping
  public void testEnvOk2(@RequestParam String urlStr) throws NamingException {
    Hashtable<String, String> env = new Hashtable<String, String>();
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
    env.put("java.naming.security.principal", urlStr);
    new InitialContext(env);
  }
}
