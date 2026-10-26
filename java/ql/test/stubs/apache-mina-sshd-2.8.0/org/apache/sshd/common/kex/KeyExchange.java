// Generated automatically from org.apache.sshd.common.kex.KeyExchange for testing purposes

package org.apache.sshd.common.kex;

import java.math.BigInteger;
import java.util.NavigableMap;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.digest.Digest;
import org.apache.sshd.common.session.Session;
import org.apache.sshd.common.session.SessionHolder;
import org.apache.sshd.common.util.buffer.Buffer;

public interface KeyExchange extends NamedResource, SessionHolder<Session>
{
    Digest getHash();
    boolean next(int p0, Buffer p1);
    byte[] getH();
    byte[] getK();
    static NavigableMap<Integer, String> GROUP_KEX_OPCODES_MAP = null;
    static NavigableMap<Integer, String> SIMPLE_KEX_OPCODES_MAP = null;
    static String getGroupKexOpcodeName(int p0){ return null; }
    static String getSimpleKexOpcodeName(int p0){ return null; }
    static boolean isValidDHValue(BigInteger p0, BigInteger p1){ return false; }
    void init(byte[] p0, byte[] p1, byte[] p2, byte[] p3);
}
