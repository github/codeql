// Generated automatically from androidx.biometric.BiometricPrompt for testing purposes

package androidx.biometric;

import android.security.identity.IdentityCredential;
import android.security.identity.PresentationSession;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
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
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult p0){}
    }
    public BiometricPrompt(Fragment p0, BiometricPrompt.AuthenticationCallback p1){}
    public BiometricPrompt(Fragment p0, Executor p1, BiometricPrompt.AuthenticationCallback p2){}
    public BiometricPrompt(FragmentActivity p0, BiometricPrompt.AuthenticationCallback p1){}
    public BiometricPrompt(FragmentActivity p0, Executor p1, BiometricPrompt.AuthenticationCallback p2){}
    public static int AUTHENTICATION_RESULT_TYPE_BIOMETRIC = 0;
    public static int AUTHENTICATION_RESULT_TYPE_DEVICE_CREDENTIAL = 0;
    public static int AUTHENTICATION_RESULT_TYPE_UNKNOWN = 0;
    public static int ERROR_CANCELED = 0;
    public static int ERROR_HW_NOT_PRESENT = 0;
    public static int ERROR_HW_UNAVAILABLE = 0;
    public static int ERROR_LOCKOUT = 0;
    public static int ERROR_LOCKOUT_PERMANENT = 0;
    public static int ERROR_NEGATIVE_BUTTON = 0;
    public static int ERROR_NO_BIOMETRICS = 0;
    public static int ERROR_NO_DEVICE_CREDENTIAL = 0;
    public static int ERROR_NO_SPACE = 0;
    public static int ERROR_SECURITY_UPDATE_REQUIRED = 0;
    public static int ERROR_TIMEOUT = 0;
    public static int ERROR_UNABLE_TO_PROCESS = 0;
    public static int ERROR_USER_CANCELED = 0;
    public static int ERROR_VENDOR = 0;
    public void authenticate(BiometricPrompt.PromptInfo p0){}
    public void authenticate(BiometricPrompt.PromptInfo p0, BiometricPrompt.CryptoObject p1){}
    public void cancelAuthentication(){}
    static public class AuthenticationResult
    {
        protected AuthenticationResult() {}
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
        public CryptoObject(PresentationSession p0){}
        public CryptoObject(Signature p0){}
        public IdentityCredential getIdentityCredential(){ return null; }
        public Mac getMac(){ return null; }
        public PresentationSession getPresentationSession(){ return null; }
        public Signature getSignature(){ return null; }
    }
    static public class PromptInfo
    {
        protected PromptInfo() {}
        public CharSequence getDescription(){ return null; }
        public CharSequence getNegativeButtonText(){ return null; }
        public CharSequence getSubtitle(){ return null; }
        public CharSequence getTitle(){ return null; }
        public boolean isConfirmationRequired(){ return false; }
        public boolean isDeviceCredentialAllowed(){ return false; }
        public int getAllowedAuthenticators(){ return 0; }
    }
}
