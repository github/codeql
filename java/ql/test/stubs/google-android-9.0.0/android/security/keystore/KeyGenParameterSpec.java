// Generated automatically from android.security.keystore.KeyGenParameterSpec for testing purposes

package android.security.keystore;

import java.math.BigInteger;
import java.security.spec.AlgorithmParameterSpec;
import java.util.Date;
import javax.security.auth.x500.X500Principal;

public class KeyGenParameterSpec implements AlgorithmParameterSpec
{
    public AlgorithmParameterSpec getAlgorithmParameterSpec(){ return null; }
    public BigInteger getCertificateSerialNumber(){ return null; }
    public Date getCertificateNotAfter(){ return null; }
    public Date getCertificateNotBefore(){ return null; }
    public Date getKeyValidityForConsumptionEnd(){ return null; }
    public Date getKeyValidityForOriginationEnd(){ return null; }
    public Date getKeyValidityStart(){ return null; }
    public String getAttestKeyAlias(){ return null; }
    public String getKeystoreAlias(){ return null; }
    public String[] getBlockModes(){ return null; }
    public String[] getDigests(){ return null; }
    public String[] getEncryptionPaddings(){ return null; }
    public String[] getSignaturePaddings(){ return null; }
    public X500Principal getCertificateSubject(){ return null; }
    public boolean isDevicePropertiesAttestationIncluded(){ return false; }
    public boolean isDigestsSpecified(){ return false; }
    public boolean isInvalidatedByBiometricEnrollment(){ return false; }
    public boolean isRandomizedEncryptionRequired(){ return false; }
    public boolean isStrongBoxBacked(){ return false; }
    public boolean isUnlockedDeviceRequired(){ return false; }
    public boolean isUserAuthenticationRequired(){ return false; }
    public boolean isUserAuthenticationValidWhileOnBody(){ return false; }
    public boolean isUserConfirmationRequired(){ return false; }
    public boolean isUserPresenceRequired(){ return false; }
    public byte[] getAttestationChallenge(){ return null; }
    public int getKeySize(){ return 0; }
    public int getMaxUsageCount(){ return 0; }
    public int getPurposes(){ return 0; }
    public int getUserAuthenticationType(){ return 0; }
    public int getUserAuthenticationValidityDurationSeconds(){ return 0; }
    static public class Builder
    {
        protected Builder() {}
        public Builder(String p0, int p1){}
        public KeyGenParameterSpec build(){ return null; }
        public KeyGenParameterSpec.Builder setAlgorithmParameterSpec(AlgorithmParameterSpec p0){ return null; }
        public KeyGenParameterSpec.Builder setAttestKeyAlias(String p0){ return null; }
        public KeyGenParameterSpec.Builder setAttestationChallenge(byte[] p0){ return null; }
        public KeyGenParameterSpec.Builder setBlockModes(String... p0){ return null; }
        public KeyGenParameterSpec.Builder setCertificateNotAfter(Date p0){ return null; }
        public KeyGenParameterSpec.Builder setCertificateNotBefore(Date p0){ return null; }
        public KeyGenParameterSpec.Builder setCertificateSerialNumber(BigInteger p0){ return null; }
        public KeyGenParameterSpec.Builder setCertificateSubject(X500Principal p0){ return null; }
        public KeyGenParameterSpec.Builder setDevicePropertiesAttestationIncluded(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setDigests(String... p0){ return null; }
        public KeyGenParameterSpec.Builder setEncryptionPaddings(String... p0){ return null; }
        public KeyGenParameterSpec.Builder setInvalidatedByBiometricEnrollment(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setIsStrongBoxBacked(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setKeySize(int p0){ return null; }
        public KeyGenParameterSpec.Builder setKeyValidityEnd(Date p0){ return null; }
        public KeyGenParameterSpec.Builder setKeyValidityForConsumptionEnd(Date p0){ return null; }
        public KeyGenParameterSpec.Builder setKeyValidityForOriginationEnd(Date p0){ return null; }
        public KeyGenParameterSpec.Builder setKeyValidityStart(Date p0){ return null; }
        public KeyGenParameterSpec.Builder setMaxUsageCount(int p0){ return null; }
        public KeyGenParameterSpec.Builder setRandomizedEncryptionRequired(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setSignaturePaddings(String... p0){ return null; }
        public KeyGenParameterSpec.Builder setUnlockedDeviceRequired(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setUserAuthenticationParameters(int p0, int p1){ return null; }
        public KeyGenParameterSpec.Builder setUserAuthenticationRequired(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setUserAuthenticationValidWhileOnBody(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setUserAuthenticationValidityDurationSeconds(int p0){ return null; }
        public KeyGenParameterSpec.Builder setUserConfirmationRequired(boolean p0){ return null; }
        public KeyGenParameterSpec.Builder setUserPresenceRequired(boolean p0){ return null; }
    }
}
