// Generated automatically from org.springframework.ldap.core.AuthenticatedLdapEntryContextMapper for testing purposes

package org.springframework.ldap.core;

import javax.naming.directory.DirContext;
import org.springframework.ldap.core.LdapEntryIdentification;

public interface AuthenticatedLdapEntryContextMapper<T>
{
    T mapWithContext(DirContext p0, LdapEntryIdentification p1);
}
