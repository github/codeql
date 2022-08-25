// Generated automatically from org.apache.sshd.common.random.Random for testing purposes

package org.apache.sshd.common.random;

import org.apache.sshd.common.NamedResource;

public interface Random extends NamedResource
{
    default void fill(byte[] p0){}
    int random(int p0);
    void fill(byte[] p0, int p1, int p2);
}
