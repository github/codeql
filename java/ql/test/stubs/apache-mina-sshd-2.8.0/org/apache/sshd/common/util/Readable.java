// Generated automatically from org.apache.sshd.common.util.Readable for testing purposes

package org.apache.sshd.common.util;

import java.nio.ByteBuffer;

public interface Readable
{
    int available();
    static Readable readable(ByteBuffer p0){ return null; }
    void getRawBytes(byte[] p0, int p1, int p2);
}
