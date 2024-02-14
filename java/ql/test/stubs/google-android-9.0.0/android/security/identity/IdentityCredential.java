// Generated automatically from android.security.identity.IdentityCredential for testing purposes

package android.security.identity;

import android.security.identity.PersonalizationData;
import android.security.identity.ResultData;
import java.security.KeyPair;
import java.security.PublicKey;
import java.security.cert.X509Certificate;
import java.time.Instant;
import java.util.Collection;
import java.util.Map;

abstract public class IdentityCredential
{
    public abstract Collection<X509Certificate> getAuthKeysNeedingCertification();
    public abstract Collection<X509Certificate> getCredentialKeyCertificateChain();
    public abstract KeyPair createEphemeralKeyPair();
    public abstract ResultData getEntries(byte[] p0, Map<String, Collection<String>> p1, byte[] p2, byte[] p3);
    public abstract byte[] decryptMessageFromReader(byte[] p0);
    public abstract byte[] encryptMessageToReader(byte[] p0);
    public abstract int[] getAuthenticationDataUsageCount();
    public abstract void setAllowUsingExhaustedKeys(boolean p0);
    public abstract void setAvailableAuthenticationKeys(int p0, int p1);
    public abstract void setReaderEphemeralPublicKey(PublicKey p0);
    public abstract void storeStaticAuthenticationData(X509Certificate p0, byte[] p1);
    public byte[] delete(byte[] p0){ return null; }
    public byte[] proveOwnership(byte[] p0){ return null; }
    public byte[] update(PersonalizationData p0){ return null; }
    public void setAllowUsingExpiredKeys(boolean p0){}
    public void storeStaticAuthenticationData(X509Certificate p0, Instant p1, byte[] p2){}
}
