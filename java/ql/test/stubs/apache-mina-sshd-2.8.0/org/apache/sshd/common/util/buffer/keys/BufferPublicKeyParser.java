// Generated automatically from org.apache.sshd.common.util.buffer.keys.BufferPublicKeyParser for testing purposes

package org.apache.sshd.common.util.buffer.keys;

import java.security.PublicKey;
import java.util.Collection;
import org.apache.sshd.common.util.buffer.Buffer;

public interface BufferPublicKeyParser<PUB extends PublicKey>
{
    PUB getRawPublicKey(String p0, Buffer p1);
    boolean isKeyTypeSupported(String p0);
    static BufferPublicKeyParser<PublicKey> DEFAULT = null;
    static BufferPublicKeyParser<PublicKey> EMPTY = null;
    static BufferPublicKeyParser<PublicKey> aggregate(Collection<? extends BufferPublicKeyParser<? extends PublicKey>> p0){ return null; }
}
