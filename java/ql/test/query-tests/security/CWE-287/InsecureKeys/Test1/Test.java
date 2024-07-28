import android.security.keystore.KeyGenParameterSpec;
import android.hardware.biometrics.BiometricPrompt;
import android.security.keystore.KeyProperties;
import javax.crypto.KeyGenerator;

class Test {
    void test() {
        KeyGenParameterSpec.Builder builder = new KeyGenParameterSpec.Builder("MySecretKey", KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT);
        builder.setUserAuthenticationRequired(false); // $insecure-key
        builder.setInvalidatedByBiometricEnrollment(false); // $insecure-key
        builder.setUserAuthenticationValidityDurationSeconds(30); // $insecure-key
    }

    private void generateSecretKey() throws Exception {
        KeyGenParameterSpec keyGenParameterSpec = new KeyGenParameterSpec.Builder(
            "MySecretKey",
            KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
            .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
            // GOOD: Secure parameters are used to generate a key for biometric authentication.
            .setUserAuthenticationRequired(true)
            .setInvalidatedByBiometricEnrollment(true)
            .setUserAuthenticationParameters(0, KeyProperties.AUTH_BIOMETRIC_STRONG)
            .build();
        KeyGenerator keyGenerator = KeyGenerator.getInstance(
                KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
        keyGenerator.init(keyGenParameterSpec);
        keyGenerator.generateKey();
    }
}

class Callback extends BiometricPrompt.AuthenticationCallback {
    public static void useKey(BiometricPrompt.CryptoObject key) {}

    @Override
    public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
        useKey(result.getCryptoObject());
    }
}