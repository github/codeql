// Generated automatically from org.springframework.ldap.core.ContextSource for testing purposes

package org.springframework.ldap.core;

import javax.naming.directory.DirContext;

public interface ContextSource
{
    DirContext getContext(String p0, String p1);
    DirContext getReadOnlyContext();
    DirContext getReadWriteContext();
}
