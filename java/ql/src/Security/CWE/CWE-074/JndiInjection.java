import javax.naming.Context;
import javax.naming.InitialContext;

public void jndiLookup(HttpServletRequest request) throws NamingException {
  String name = request.getParameter("name");

  Hashtable<String, String> env = new Hashtable<String, String>();
  env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
  env.put(Context.PROVIDER_URL, "rmi://trusted-server:1099");
  InitialContext ctx = new InitialContext(env);

  // BAD: User input used in lookup
  ctx.lookup(name);

  // GOOD: The name is validated before being used in lookup
  if (isValid(name)) {
    ctx.lookup(name);
  } else {
    // Reject the request
  }
}