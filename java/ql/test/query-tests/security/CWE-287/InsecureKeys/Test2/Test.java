import android.security.keystore.KeyGenParameterSpec;
import android.hardware.biometrics.BiometricPrompt;
import android.security.keystore.KeyProperties;

class Test {
    void test() {
        KeyGenParameterSpec.Builder builder = new KeyGenParameterSpec.Builder("MySecretKey", KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT);
        // No alert as there is no use of biometric authentication in this application.
        builder.setUserAuthenticationRequired(false); 
        builder.setInvalidatedByBiometricEnrollment(false); 
        builder.setUserAuthenticationValidityDurationSeconds(30); 
    }
}