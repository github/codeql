// Generated automatically from org.ietf.jgss.GSSName for testing purposes

package org.ietf.jgss;

import org.ietf.jgss.Oid;

public interface GSSName
{
    GSSName canonicalize(Oid p0);
    Oid getStringNameType();
    String toString();
    boolean equals(GSSName p0);
    boolean equals(Object p0);
    boolean isAnonymous();
    boolean isMN();
    byte[] export();
    int hashCode();
    static Oid NT_ANONYMOUS = null;
    static Oid NT_EXPORT_NAME = null;
    static Oid NT_HOSTBASED_SERVICE = null;
    static Oid NT_MACHINE_UID_NAME = null;
    static Oid NT_STRING_UID_NAME = null;
    static Oid NT_USER_NAME = null;
}
