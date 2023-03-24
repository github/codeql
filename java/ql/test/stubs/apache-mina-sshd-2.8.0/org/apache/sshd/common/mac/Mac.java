// Generated automatically from org.apache.sshd.common.mac.Mac for testing purposes

package org.apache.sshd.common.mac;

import org.apache.sshd.common.mac.MacInformation;

public interface Mac extends MacInformation
{
    default byte[] doFinal(){ return null; }
    default void doFinal(byte[] p0){}
    default void update(byte[] p0){}
    static boolean equals(byte[] p0, int p1, byte[] p2, int p3, int p4){ return false; }
    void doFinal(byte[] p0, int p1);
    void init(byte[] p0);
    void update(byte[] p0, int p1, int p2);
    void updateUInt(long p0);
}
