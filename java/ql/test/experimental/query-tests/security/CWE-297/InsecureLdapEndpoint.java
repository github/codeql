import java.util.Hashtable;
import java.util.Properties;
import javax.naming.Context;

public class InsecureLdapEndpoint {
    private static String PROP_DISABLE_LDAP_ENDPOINT_IDENTIFICATION = "com.sun.jndi.ldap.object.disableEndpointIdentification";

    // BAD - Test configuration with disabled LDAPS endpoint check using `System.setProperty()`.
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

    // GOOD - Test configuration without disabling LDAPS endpoint check.
    public Hashtable<String, String> createConnectionEnv2() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        return env;
    }

    // BAD - Test configuration with disabled LDAPS endpoint check using `System.setProperties()`.
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

    // BAD - Test configuration with disabled LDAPS endpoint check using `HashTable.put()`.
    public Hashtable<String, String> createConnectionEnv4() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        // Disable SSL endpoint check
        Properties properties = new Properties();
        properties.put("com.sun.jndi.ldap.object.disableEndpointIdentification", "true");
        System.setProperties(properties);

        return env;
    }

    // BAD - Test configuration with disabled LDAPS endpoint check using the `TRUE` boolean field.
    public Hashtable<String, String> createConnectionEnv5() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        // Disable SSL endpoint check
        System.setProperty(PROP_DISABLE_LDAP_ENDPOINT_IDENTIFICATION, Boolean.TRUE.toString());

        return env;
    }

    // BAD - Test configuration with disabled LDAPS endpoint check using a boolean value.
    public Hashtable<String, String> createConnectionEnv6() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        // Disable SSL endpoint check
        Properties properties = new Properties();
        properties.put("com.sun.jndi.ldap.object.disableEndpointIdentification", true);
        System.setProperties(properties);

        return env;
    }
}
