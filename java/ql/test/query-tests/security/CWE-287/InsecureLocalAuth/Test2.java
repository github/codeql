import androidx.biometric.BiometricPrompt;

class TestC {
    public static void useKey(BiometricPrompt.CryptoObject key) {}


    // GOOD: result is used
    class Test1 extends BiometricPrompt.AuthenticationCallback {
        @Override
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
            TestC.useKey(result.getCryptoObject());
        }
    }

    // BAD: result is not used
    class Test2 extends BiometricPrompt.AuthenticationCallback {
        @Override
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) { // $insecure-auth
            
        }
    }

    // BAD: result is only used in a super call
    class Test3 extends BiometricPrompt.AuthenticationCallback {
        @Override
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) { // $insecure-auth
            super.onAuthenticationSucceeded(result);
        }
    }

    // GOOD: result is used
    class Test4 extends BiometricPrompt.AuthenticationCallback {
        @Override
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
            super.onAuthenticationSucceeded(result);
            TestC.useKey(result.getCryptoObject());
        }
    }

    // GOOD: result is used in a super call to a class other than the base class
    class Test5 extends Test1 {
        @Override
        public void onAuthenticationSucceeded(BiometricPrompt.AuthenticationResult result) {
            super.onAuthenticationSucceeded(result);
        }
    }
}