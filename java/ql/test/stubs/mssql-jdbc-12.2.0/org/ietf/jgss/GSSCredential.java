// Generated automatically from org.ietf.jgss.GSSCredential for testing purposes

package org.ietf.jgss;

import org.ietf.jgss.GSSName;
import org.ietf.jgss.Oid;

public interface GSSCredential extends Cloneable
{
    GSSName getName();
    GSSName getName(Oid p0);
    Oid[] getMechs();
    boolean equals(Object p0);
    int getRemainingAcceptLifetime(Oid p0);
    int getRemainingInitLifetime(Oid p0);
    int getRemainingLifetime();
    int getUsage();
    int getUsage(Oid p0);
    int hashCode();
    static int ACCEPT_ONLY = 0;
    static int DEFAULT_LIFETIME = 0;
    static int INDEFINITE_LIFETIME = 0;
    static int INITIATE_AND_ACCEPT = 0;
    static int INITIATE_ONLY = 0;
    void add(GSSName p0, int p1, int p2, Oid p3, int p4);
    void dispose();
}
