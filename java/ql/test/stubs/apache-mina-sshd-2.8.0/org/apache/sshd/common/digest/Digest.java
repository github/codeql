// Generated automatically from org.apache.sshd.common.digest.Digest for testing purposes

package org.apache.sshd.common.digest;

import org.apache.sshd.common.digest.DigestInformation;

public interface Digest extends Comparable<Digest>, DigestInformation
{
    byte[] digest();
    void init();
    void update(byte[] p0);
    void update(byte[] p0, int p1, int p2);
}
