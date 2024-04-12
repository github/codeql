private void generateSecretKey() {
    KeyGenParameterSpec keyGenParameterSpec = new KeyGenParameterSpec.Builder(
        "MySecretKey",
        KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
        .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
        .setUserAuthenticationRequired(true)
        .setInvalidatedByBiometricEnrollment(true)
        .build();
    KeyGenerator keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
    keyGenerator.init(keyGenParameterSpec);
    keyGenerator.generateKey();
}


private SecretKey getSecretKey() {
    KeyStore keyStore = KeyStore.getInstance("AndroidKeyStore");
    keyStore.load(null);
    return ((SecretKey)keyStore.getKey("MySecretKey", null));
}

private Cipher getCipher() {
    return Cipher.getInstance(KeyProperties.KEY_ALGORITHM_AES + "/"
            + KeyProperties.BLOCK_MODE_CBC + "/"
            + KeyProperties.ENCRYPTION_PADDING_PKCS7);
}

public prompt(byte[] encryptedData) {
    Cipher cipher = getCipher();
    SecretKey secretKey = getSecretKey();
    cipher.init(Cipher.DECRYPT_MODE, secretKey);

    biometricPrompt.authenticate(
        new BiometricPrompt.CryptoObject(cipher),
        cancellationSignal,
        executor,
        new BiometricPrompt.AuthenticationCallback() {
            @Override
            // GOOD: This authentication callback uses the result to decrypt some data.
            public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
                Cipher cipher = result.getCryptoObject().getCipher();
                byte[] decryptedData = cipher.doFinal(encryptedData);
                grantAccessWithData(decryptedData);
            }
        }
    );
}