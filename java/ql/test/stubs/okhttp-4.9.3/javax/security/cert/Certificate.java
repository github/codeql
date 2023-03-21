// Generated automatically from javax.security.cert.Certificate for testing purposes

package javax.security.cert;

import java.security.PublicKey;

abstract public class Certificate
{
    public Certificate(){}
    public abstract PublicKey getPublicKey();
    public abstract String toString();
    public abstract byte[] getEncoded();
    public abstract void verify(PublicKey p0);
    public abstract void verify(PublicKey p0, String p1);
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
}
