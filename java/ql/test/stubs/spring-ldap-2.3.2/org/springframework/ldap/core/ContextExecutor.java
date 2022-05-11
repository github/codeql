// Generated automatically from org.springframework.ldap.core.ContextExecutor for testing purposes

package org.springframework.ldap.core;

import javax.naming.directory.DirContext;

public interface ContextExecutor<T>
{
    T executeWithContext(DirContext p0);
}
