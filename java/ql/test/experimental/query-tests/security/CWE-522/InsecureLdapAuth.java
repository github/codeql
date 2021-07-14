import java.util.Hashtable;

import javax.naming.Context;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.ldap.InitialLdapContext;

public class InsecureLdapAuth {
	// BAD - Test LDAP authentication in cleartext using `DirContext`.
	public void testCleartextLdapAuth(String ldapUserName, String password) throws Exception {
		String ldapUrl = "ldap://ad.your-server.com:389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		environment.put(Context.REFERRAL, "follow");
		environment.put(Context.SECURITY_AUTHENTICATION, "simple");
		environment.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		environment.put(Context.SECURITY_CREDENTIALS, password);
		DirContext dirContext = new InitialDirContext(environment);
	}

	// BAD - Test LDAP authentication in cleartext using `DirContext`.
	public void testCleartextLdapAuth(String ldapUserName, String password, String serverName) throws Exception {
		String ldapUrl = "ldap://"+serverName+":389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		environment.put(Context.REFERRAL, "follow");
		environment.put(Context.SECURITY_AUTHENTICATION, "simple");
		environment.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		environment.put(Context.SECURITY_CREDENTIALS, password);
		DirContext dirContext = new InitialDirContext(environment);
	}

	// GOOD - Test LDAP authentication over SSL.
	public void testSslLdapAuth(String ldapUserName, String password) throws Exception {
		String ldapUrl = "ldaps://ad.your-server.com:636";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		environment.put(Context.REFERRAL, "follow");
		environment.put(Context.SECURITY_AUTHENTICATION, "simple");
		environment.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		environment.put(Context.SECURITY_CREDENTIALS, password);
		DirContext dirContext = new InitialDirContext(environment);
	}

	// GOOD - Test LDAP authentication over SSL.
	public void testSslLdapAuth2(String ldapUserName, String password) throws Exception {
		String ldapUrl = "ldap://ad.your-server.com:636";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		environment.put(Context.REFERRAL, "follow");
		environment.put(Context.SECURITY_AUTHENTICATION, "simple");
		environment.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		environment.put(Context.SECURITY_CREDENTIALS, password);
		environment.put(Context.SECURITY_PROTOCOL, "ssl");
		DirContext dirContext = new InitialDirContext(environment);
	}

	// GOOD - Test LDAP authentication with SASL authentication.
	public void testSaslLdapAuth(String ldapUserName, String password) throws Exception {
		String ldapUrl = "ldap://ad.your-server.com:389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		environment.put(Context.REFERRAL, "follow");
		environment.put(Context.SECURITY_AUTHENTICATION, "DIGEST-MD5 GSSAPI");
		environment.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		environment.put(Context.SECURITY_CREDENTIALS, password);
		DirContext dirContext = new InitialDirContext(environment);
	}

	// GOOD - Test LDAP authentication in cleartext connecting to local LDAP server.
	public void testCleartextLdapAuth2(String ldapUserName, String password) throws Exception {
		String ldapUrl = "ldap://localhost:389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		environment.put(Context.REFERRAL, "follow");
		environment.put(Context.SECURITY_AUTHENTICATION, "simple");
		environment.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		environment.put(Context.SECURITY_CREDENTIALS, password);
		DirContext dirContext = new InitialDirContext(environment);
	}

	// BAD - Test LDAP authentication in cleartext using `InitialLdapContext`.
	public void testCleartextLdapAuth3(String ldapUserName, String password) throws Exception {
		String ldapUrl = "ldap://ad.your-server.com:389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		environment.put(Context.REFERRAL, "follow");
		environment.put(Context.SECURITY_AUTHENTICATION, "simple");
		environment.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		environment.put(Context.SECURITY_CREDENTIALS, password);
		InitialLdapContext ldapContext = new InitialLdapContext(environment, null);
	}	


	// BAD - Test LDAP authentication in cleartext using `DirContext` and string literals.
	public void testCleartextLdapAuth4(String ldapUserName, String password) throws Exception {
		String ldapUrl = "ldap://ad.your-server.com:389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put("java.naming.factory.initial",
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put("java.naming.provider.url", ldapUrl);
		environment.put("java.naming.referral", "follow");
		environment.put("java.naming.security.authentication", "simple");
		environment.put("java.naming.security.principal", ldapUserName);
		environment.put("java.naming.security.credentials", password);
		DirContext dirContext = new InitialDirContext(environment);
	}

	private void setSSL(Hashtable env) {
		env.put(Context.SECURITY_PROTOCOL, "ssl");
	}

	private void setBasicAuth(Hashtable env, String ldapUserName, String password) {
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.SECURITY_PRINCIPAL, ldapUserName);
		env.put(Context.SECURITY_CREDENTIALS, password);
	}

	// GOOD - Test LDAP authentication with `ssl` configuration and basic authentication.
	public void testCleartextLdapAuth5(String ldapUserName, String password, String serverName) throws Exception {
		String ldapUrl = "ldap://"+serverName+":389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		setSSL(environment);
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		setBasicAuth(environment, ldapUserName, password);
		DirContext dirContext = new InitialLdapContext(environment, null);
	}

	// BAD - Test LDAP authentication with basic authentication.
	public void testCleartextLdapAuth6(String ldapUserName, String password, String serverName) throws Exception {
		String ldapUrl = "ldap://"+serverName+":389";
		Hashtable<String, String> environment = new Hashtable<String, String>();
		environment.put(Context.INITIAL_CONTEXT_FACTORY,
			"com.sun.jndi.ldap.LdapCtxFactory");
		environment.put(Context.PROVIDER_URL, ldapUrl);
		setBasicAuth(environment, ldapUserName, password);
		DirContext dirContext = new InitialLdapContext(environment, null);
	}
}
