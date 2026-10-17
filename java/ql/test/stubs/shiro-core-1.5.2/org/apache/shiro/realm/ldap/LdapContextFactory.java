// Generated automatically from org.apache.shiro.realm.ldap.LdapContextFactory for testing purposes

package org.apache.shiro.realm.ldap;

import javax.naming.NamingException;
import javax.naming.ldap.LdapContext;

public interface LdapContextFactory
{
    LdapContext getSystemLdapContext() throws NamingException;

    LdapContext getLdapContext(Object principal, Object credentials) throws NamingException;
}
