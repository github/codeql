// Generated automatically from org.springframework.ldap.core.AuthenticatedLdapEntryContextCallback for testing purposes

package org.springframework.ldap.core;

import javax.naming.directory.DirContext;
import org.springframework.ldap.core.LdapEntryIdentification;

public interface AuthenticatedLdapEntryContextCallback
{
    void executeWithContext(DirContext p0, LdapEntryIdentification p1);
}
