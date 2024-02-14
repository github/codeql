// Generated automatically from android.hardware.fingerprint.FingerprintManager for testing purposes

package android.hardware.fingerprint;

import android.os.CancellationSignal;
import android.os.Handler;
import java.security.Signature;
import javax.crypto.Cipher;
import javax.crypto.Mac;

public class FingerprintManager
{
    abstract static public class AuthenticationCallback
    {
        public AuthenticationCallback(){}
        public void onAuthenticationError(int p0, CharSequence p1){}
        public void onAuthenticationFailed(){}
        public void onAuthenticationHelp(int p0, CharSequence p1){}
        public void onAuthenticationSucceeded(FingerprintManager.AuthenticationResult p0){}
    }
    public boolean hasEnrolledFingerprints(){ return false; }
    public boolean isHardwareDetected(){ return false; }
    public static int FINGERPRINT_ACQUIRED_GOOD = 0;
    public static int FINGERPRINT_ACQUIRED_IMAGER_DIRTY = 0;
    public static int FINGERPRINT_ACQUIRED_INSUFFICIENT = 0;
    public static int FINGERPRINT_ACQUIRED_PARTIAL = 0;
    public static int FINGERPRINT_ACQUIRED_TOO_FAST = 0;
    public static int FINGERPRINT_ACQUIRED_TOO_SLOW = 0;
    public static int FINGERPRINT_ERROR_CANCELED = 0;
    public static int FINGERPRINT_ERROR_HW_NOT_PRESENT = 0;
    public static int FINGERPRINT_ERROR_HW_UNAVAILABLE = 0;
    public static int FINGERPRINT_ERROR_LOCKOUT = 0;
    public static int FINGERPRINT_ERROR_LOCKOUT_PERMANENT = 0;
    public static int FINGERPRINT_ERROR_NO_FINGERPRINTS = 0;
    public static int FINGERPRINT_ERROR_NO_SPACE = 0;
    public static int FINGERPRINT_ERROR_TIMEOUT = 0;
    public static int FINGERPRINT_ERROR_UNABLE_TO_PROCESS = 0;
    public static int FINGERPRINT_ERROR_USER_CANCELED = 0;
    public static int FINGERPRINT_ERROR_VENDOR = 0;
    public void authenticate(FingerprintManager.CryptoObject p0, CancellationSignal p1, int p2, FingerprintManager.AuthenticationCallback p3, Handler p4){}
    static public class AuthenticationResult
    {
        public FingerprintManager.CryptoObject getCryptoObject(){ return null; }
    }
    static public class CryptoObject
    {
        protected CryptoObject() {}
        public Cipher getCipher(){ return null; }
        public CryptoObject(Cipher p0){}
        public CryptoObject(Mac p0){}
        public CryptoObject(Signature p0){}
        public Mac getMac(){ return null; }
        public Signature getSignature(){ return null; }
    }
}
