biometricPrompt.authenticate(
    cancellationSignal,
    executor,
    new BiometricPrompt.AuthenticationCallback {
        @Override
        // BAD: This authentication callback does not make use of a `CryptoObject` from the `result`.
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
            grantAccess()
        }
    }
)