// Generated automatically from org.apache.sshd.common.config.keys.OpenSshCertificate for testing purposes

package org.apache.sshd.common.config.keys;

import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Collection;
import java.util.List;

public interface OpenSshCertificate extends PrivateKey, PublicKey
{
    Collection<String> getPrincipals();
    List<OpenSshCertificate.CertificateOption> getCriticalOptions();
    List<OpenSshCertificate.CertificateOption> getExtensions();
    OpenSshCertificate.Type getType();
    PublicKey getCaPubKey();
    PublicKey getCertPubKey();
    String getId();
    String getKeyType();
    String getRawKeyType();
    String getReserved();
    String getSignatureAlgorithm();
    byte[] getMessage();
    byte[] getNonce();
    byte[] getRawSignature();
    byte[] getSignature();
    long getSerial();
    long getValidAfter();
    long getValidBefore();
    static boolean isValidNow(OpenSshCertificate p0){ return false; }
    static long INFINITY = 0;
    static long MIN_EPOCH = 0;
    static public class CertificateOption
    {
        protected CertificateOption() {}
        public CertificateOption(String p0){}
        public CertificateOption(String p0, String p1){}
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public final String getData(){ return null; }
        public final String getName(){ return null; }
        public int hashCode(){ return 0; }
    }
    static public enum Type
    {
        HOST, USER;
        private Type() {}
        public int getCode(){ return 0; }
        public static OpenSshCertificate.Type fromCode(int p0){ return null; }
    }
}
