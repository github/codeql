import javax.naming.CompositeName;
import javax.naming.InitialContext;
import javax.naming.Name;
import javax.naming.NamingException;
import javax.naming.directory.InitialDirContext;
import javax.naming.ldap.InitialLdapContext;

import org.springframework.jndi.JndiTemplate;
import org.springframework.web.bind.annotation.RequestParam;

public class JndiInjection {
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

  public void testInitialDirContextBad1(@RequestParam String nameStr) throws NamingException {
    Name name = new CompositeName(nameStr);
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

  public void testSpringJndiTemplateBad1(@RequestParam String nameStr) throws NamingException {
    JndiTemplate ctx = new JndiTemplate();

    ctx.lookup(nameStr);
    ctx.lookup(nameStr, null);
  }

  public void testShiroJndiTemplateBad1(@RequestParam String nameStr) throws NamingException {
    org.apache.shiro.jndi.JndiTemplate ctx = new org.apache.shiro.jndi.JndiTemplate();

    ctx.lookup(nameStr);
    ctx.lookup(nameStr, null);
  }
}
