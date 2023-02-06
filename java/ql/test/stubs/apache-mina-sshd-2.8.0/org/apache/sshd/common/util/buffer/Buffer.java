// Generated automatically from org.apache.sshd.common.util.buffer.Buffer for testing purposes

package org.apache.sshd.common.util.buffer;

import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.security.KeyPair;
import java.security.PublicKey;
import java.security.spec.ECParameterSpec;
import java.util.Collection;
import java.util.List;
import java.util.function.IntUnaryOperator;
import java.util.logging.Level;
import org.apache.sshd.common.PropertyResolver;
import org.apache.sshd.common.config.keys.OpenSshCertificate;
import org.apache.sshd.common.util.Readable;
import org.apache.sshd.common.util.buffer.keys.BufferPublicKeyParser;
import org.apache.sshd.common.util.logging.SimplifiedLog;

abstract public class Buffer implements Readable
{
    protected Buffer(){}
    protected KeyPair extractEC(String p0, ECParameterSpec p1){ return null; }
    protected abstract int size();
    protected abstract void copyRawBytes(int p0, byte[] p1, int p2, int p3);
    protected final byte[] workBuf = null;
    public BigInteger getMPInt(){ return null; }
    public Buffer clear(){ return null; }
    public Buffer ensureCapacity(int p0){ return null; }
    public Collection<String> getAvailableStrings(){ return null; }
    public Collection<String> getAvailableStrings(Charset p0){ return null; }
    public Collection<String> getStringList(boolean p0){ return null; }
    public Collection<String> getStringList(boolean p0, Charset p1){ return null; }
    public KeyPair getKeyPair(){ return null; }
    public List<OpenSshCertificate.CertificateOption> getCertificateOptions(){ return null; }
    public List<OpenSshCertificate.CertificateOption> getCertificateOptions(Charset p0){ return null; }
    public List<String> getNameList(){ return null; }
    public List<String> getNameList(Charset p0){ return null; }
    public List<String> getNameList(Charset p0, char p1){ return null; }
    public List<String> getNameList(char p0){ return null; }
    public List<String> getStringList(int p0){ return null; }
    public List<String> getStringList(int p0, Charset p1){ return null; }
    public PublicKey getPublicKey(){ return null; }
    public PublicKey getPublicKey(BufferPublicKeyParser<? extends PublicKey> p0){ return null; }
    public PublicKey getRawPublicKey(){ return null; }
    public PublicKey getRawPublicKey(BufferPublicKeyParser<? extends PublicKey> p0){ return null; }
    public String getString(){ return null; }
    public String toHex(){ return null; }
    public String toString(){ return null; }
    public abstract Buffer clear(boolean p0);
    public abstract Buffer ensureCapacity(int p0, IntUnaryOperator p1);
    public abstract String getString(Charset p0);
    public abstract byte[] array();
    public abstract byte[] getBytesConsumed();
    public abstract int capacity();
    public abstract int putBuffer(Readable p0, boolean p1);
    public abstract int rpos();
    public abstract int wpos();
    public abstract void compact();
    public abstract void putBuffer(ByteBuffer p0);
    public abstract void putRawBytes(byte[] p0, int p1, int p2);
    public abstract void rpos(int p0);
    public abstract void wpos(int p0);
    public boolean getBoolean(){ return false; }
    public boolean isValidMessageStructure(Class<? extends Object>... p0){ return false; }
    public boolean isValidMessageStructure(Collection<Class<? extends Object>> p0){ return false; }
    public byte getByte(){ return 0; }
    public byte rawByte(int p0){ return 0; }
    public byte[] getBytes(){ return null; }
    public byte[] getCompactData(){ return null; }
    public byte[] getMPIntAsBytes(){ return null; }
    public int ensureAvailable(int p0){ return 0; }
    public int getInt(){ return 0; }
    public int getUByte(){ return 0; }
    public long getLong(){ return 0; }
    public long getUInt(){ return 0; }
    public long rawUInt(int p0){ return 0; }
    public short getShort(){ return 0; }
    public void dumpHex(SimplifiedLog p0, Level p1, String p2, PropertyResolver p3){}
    public void dumpHex(SimplifiedLog p0, String p1, PropertyResolver p2){}
    public void getRawBytes(byte[] p0){}
    public void putAndWipeBytes(byte[] p0){}
    public void putAndWipeBytes(byte[] p0, int p1, int p2){}
    public void putAndWipeChars(char[] p0){}
    public void putAndWipeChars(char[] p0, Charset p1){}
    public void putAndWipeChars(char[] p0, int p1, int p2){}
    public void putAndWipeChars(char[] p0, int p1, int p2, Charset p3){}
    public void putBoolean(boolean p0){}
    public void putBuffer(Readable p0){}
    public void putBufferedData(Object p0){}
    public void putByte(byte p0){}
    public void putBytes(byte[] p0){}
    public void putBytes(byte[] p0, int p1, int p2){}
    public void putCertificateOptions(List<OpenSshCertificate.CertificateOption> p0){}
    public void putCertificateOptions(List<OpenSshCertificate.CertificateOption> p0, Charset p1){}
    public void putChars(char[] p0){}
    public void putChars(char[] p0, Charset p1){}
    public void putChars(char[] p0, int p1, int p2){}
    public void putChars(char[] p0, int p1, int p2, Charset p3){}
    public void putInt(long p0){}
    public void putKeyPair(KeyPair p0){}
    public void putLong(long p0){}
    public void putMPInt(BigInteger p0){}
    public void putMPInt(byte[] p0){}
    public void putNameList(Collection<String> p0){}
    public void putNameList(Collection<String> p0, Charset p1){}
    public void putNameList(Collection<String> p0, Charset p1, char p2){}
    public void putNameList(Collection<String> p0, char p1){}
    public void putOptionalBufferedData(Object p0){}
    public void putPublicKey(PublicKey p0){}
    public void putRawBytes(byte[] p0){}
    public void putRawPublicKey(PublicKey p0){}
    public void putRawPublicKeyBytes(PublicKey p0){}
    public void putShort(int p0){}
    public void putString(String p0){}
    public void putString(String p0, Charset p1){}
    public void putStringList(Collection<? extends Object> p0, Charset p1, boolean p2){}
    public void putStringList(Collection<? extends Object> p0, boolean p1){}
}
