public class InsecureLdapEndpoint2 {
    public Hashtable<String, String> createConnectionEnv() {
        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldaps://ad.your-server.com:636");

        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "username");
        env.put(Context.SECURITY_CREDENTIALS, "secpassword");

        // GOOD - No configuration to disable SSL endpoint check since it is enabled by default.
        {
        }

        return env;
    }
}
