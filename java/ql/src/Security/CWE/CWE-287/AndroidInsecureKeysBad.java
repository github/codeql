private void generateSecretKey() {
    KeyGenParameterSpec keyGenParameterSpec = new KeyGenParameterSpec.Builder(
        "MySecretKey",
        KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
        .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
        // BAD: User authentication is not required to use this key.
        .setUserAuthenticationRequired(false)
        .build();
    KeyGenerator keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
    keyGenerator.init(keyGenParameterSpec);
    keyGenerator.generateKey();
}

private void generateSecretKey() {
    KeyGenParameterSpec keyGenParameterSpec = new KeyGenParameterSpec.Builder(
        "MySecretKey",
        KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
        .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
        .setUserAuthenticationRequired(true)
        // BAD: An attacker can access this key by enrolling additional biometrics.
        .setInvalidatedByBiometricEnrollment(false)
        .build();
    KeyGenerator keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
    keyGenerator.init(keyGenParameterSpec);
    keyGenerator.generateKey();
}

private void generateSecretKey() {
    KeyGenParameterSpec keyGenParameterSpec = new KeyGenParameterSpec.Builder(
        "MySecretKey",
        KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
        .setBlockModes(KeyProperties.BLOCK_MODE_CBC)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_PKCS7)
        .setUserAuthenticationRequired(true)
        .setInvalidatedByBiometricEnrollment(true)
        // BAD: This key can be accessed using non-biometric credentials. 
        .setUserAuthenticationValidityDurationSeconds(30)
        .build();
    KeyGenerator keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
    keyGenerator.init(keyGenParameterSpec);
    keyGenerator.generateKey();
}