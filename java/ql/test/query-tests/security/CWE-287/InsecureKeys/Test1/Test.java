import android.security.keystore.KeyGenParameterSpec;
import android.hardware.biometrics.BiometricPrompt;
import android.security.keystore.KeyProperties;

class Test {
    void test() {
        KeyGenParameterSpec.Builder builder = new KeyGenParameterSpec.Builder("MySecretKey", KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT);
        builder.setUserAuthenticationRequired(false); // $insecure-key
        builder.setInvalidatedByBiometricEnrollment(false); // $insecure-key
        builder.setUserAuthenticationValidityDurationSeconds(30); // $insecure-key
    }
}

class Callback extends BiometricPrompt.AuthenticationCallback {
    public static void useKey(BiometricPrompt.CryptoObject key) {}

    @Override
    public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
        useKey(result.getCryptoObject());
    }
}