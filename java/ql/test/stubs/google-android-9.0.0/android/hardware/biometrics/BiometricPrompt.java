// Generated automatically from android.hardware.biometrics.BiometricPrompt for testing purposes

package android.hardware.biometrics;

import android.os.CancellationSignal;
import android.security.identity.IdentityCredential;
import java.security.Signature;
import java.util.concurrent.Executor;
import javax.crypto.Cipher;
import javax.crypto.Mac;

public class BiometricPrompt
{
    protected BiometricPrompt() {}
    abstract static public class AuthenticationCallback
    {
        public AuthenticationCallback(){}
        public void onAuthenticationError(int p0, CharSequence p1){}
        public void onAuthenticationFailed(){}
        public void onAuthenticationHelp(int p0, CharSequence p1){}
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult p0){}
    }
    public CharSequence getDescription(){ return null; }
    public CharSequence getNegativeButtonText(){ return null; }
    public CharSequence getSubtitle(){ return null; }
    public CharSequence getTitle(){ return null; }
    public boolean isConfirmationRequired(){ return false; }
    public int getAllowedAuthenticators(){ return 0; }
    public static int AUTHENTICATION_RESULT_TYPE_BIOMETRIC = 0;
    public static int AUTHENTICATION_RESULT_TYPE_DEVICE_CREDENTIAL = 0;
    public static int BIOMETRIC_ACQUIRED_GOOD = 0;
    public static int BIOMETRIC_ACQUIRED_IMAGER_DIRTY = 0;
    public static int BIOMETRIC_ACQUIRED_INSUFFICIENT = 0;
    public static int BIOMETRIC_ACQUIRED_PARTIAL = 0;
    public static int BIOMETRIC_ACQUIRED_TOO_FAST = 0;
    public static int BIOMETRIC_ACQUIRED_TOO_SLOW = 0;
    public static int BIOMETRIC_ERROR_CANCELED = 0;
    public static int BIOMETRIC_ERROR_HW_NOT_PRESENT = 0;
    public static int BIOMETRIC_ERROR_HW_UNAVAILABLE = 0;
    public static int BIOMETRIC_ERROR_LOCKOUT = 0;
    public static int BIOMETRIC_ERROR_LOCKOUT_PERMANENT = 0;
    public static int BIOMETRIC_ERROR_NO_BIOMETRICS = 0;
    public static int BIOMETRIC_ERROR_NO_DEVICE_CREDENTIAL = 0;
    public static int BIOMETRIC_ERROR_NO_SPACE = 0;
    public static int BIOMETRIC_ERROR_SECURITY_UPDATE_REQUIRED = 0;
    public static int BIOMETRIC_ERROR_TIMEOUT = 0;
    public static int BIOMETRIC_ERROR_UNABLE_TO_PROCESS = 0;
    public static int BIOMETRIC_ERROR_USER_CANCELED = 0;
    public static int BIOMETRIC_ERROR_VENDOR = 0;
    public void authenticate(BiometricPrompt.CryptoObject p0, CancellationSignal p1, Executor p2, BiometricPrompt.AuthenticationCallback p3){}
    public void authenticate(CancellationSignal p0, Executor p1, BiometricPrompt.AuthenticationCallback p2){}
    static public class AuthenticationResult
    {
        public BiometricPrompt.CryptoObject getCryptoObject(){ return null; }
        public int getAuthenticationType(){ return 0; }
    }
    static public class CryptoObject
    {
        protected CryptoObject() {}
        public Cipher getCipher(){ return null; }
        public CryptoObject(Cipher p0){}
        public CryptoObject(IdentityCredential p0){}
        public CryptoObject(Mac p0){}
        public CryptoObject(Signature p0){}
        public IdentityCredential getIdentityCredential(){ return null; }
        public Mac getMac(){ return null; }
        public Signature getSignature(){ return null; }
    }
}
