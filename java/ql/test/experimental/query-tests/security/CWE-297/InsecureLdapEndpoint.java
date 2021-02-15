import java.util.Hashtable;
import java.util.Properties;
import javax.naming.Context;

public class InsecureLdapEndpoint {
    // BAD - Test configuration with disabled SSL endpoint check.
    public Hashtable<String, String> createConnectionEnv() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        // Disable SSL endpoint check
        System.setProperty("com.sun.jndi.ldap.object.disableEndpointIdentification", "true");

        return env;
    }

    // GOOD - Test configuration without disabling SSL endpoint check.
    public Hashtable<String, String> createConnectionEnv2() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        return env;
    }

    // BAD - Test configuration with disabled SSL endpoint check.
    public Hashtable<String, String> createConnectionEnv3() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        // Disable SSL endpoint check
        Properties properties = new Properties();
        properties.setProperty("com.sun.jndi.ldap.object.disableEndpointIdentification", "true");
        System.setProperties(properties);

        return env;
    }
}
