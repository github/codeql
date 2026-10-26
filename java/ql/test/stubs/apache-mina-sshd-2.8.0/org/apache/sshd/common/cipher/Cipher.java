// Generated automatically from org.apache.sshd.common.cipher.Cipher for testing purposes

package org.apache.sshd.common.cipher;

import org.apache.sshd.common.cipher.CipherInformation;

public interface Cipher extends CipherInformation
{
    default void update(byte[] p0){}
    default void updateAAD(byte[] p0){}
    default void updateWithAAD(byte[] p0, int p1, int p2, int p3){}
    static boolean checkSupported(String p0, int p1){ return false; }
    static public enum Mode
    {
        Decrypt, Encrypt;
        private Mode() {}
    }
    void init(Cipher.Mode p0, byte[] p1, byte[] p2);
    void update(byte[] p0, int p1, int p2);
    void updateAAD(byte[] p0, int p1, int p2);
}
