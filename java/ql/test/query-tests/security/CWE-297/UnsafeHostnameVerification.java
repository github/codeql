import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;
import java.security.cert.Certificate;

public class UnsafeHostnameVerification {

    private static final boolean DISABLE_VERIFICATION = true;

    /**
     * Test the implementation of trusting all hostnames as an anonymous class
     */
    public void testTrustAllHostnameOfAnonymousClass() {
        HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
            @Override
            public boolean verify(String hostname, SSLSession session) {
                return true; // BAD, always returns true
            }
        });
    }

    /**
     * Test the implementation of trusting all hostnames as a lambda.
     */
    public void testTrustAllHostnameLambda() {
        HttpsURLConnection.setDefaultHostnameVerifier((name, s) -> true); // BAD, always returns true
    }

    /**
     * Test an all-trusting hostname verifier that is guarded by a flag
     */
    public void testGuardedByFlagTrustAllHostname() {
        if (DISABLE_VERIFICATION) {
            HttpsURLConnection.setDefaultHostnameVerifier(ALLOW_ALL_HOSTNAME_VERIFIER); // GOOD: The all-trusting
                                                                                        // hostname verifier is guarded
                                                                                        // by a feature flag
        }
    }

    public void testGuardedByFlagAccrossCalls() {
        if (DISABLE_VERIFICATION) {
            functionThatActuallyDisablesVerification();
        }
    }

    private void functionThatActuallyDisablesVerification() {
        HttpsURLConnection.setDefaultHostnameVerifier((name, s) -> true); // GOOD [but detected as BAD], because we only
                                                                          // check guards inside a function
        // and not across function calls. This is considerer GOOD because the call to
        // `functionThatActuallyDisablesVerification` is guarded by a feature flag in
        // `testGuardedByFlagAccrossCalls`.
        // Although this is not ideal as another function could directly call
        // `functionThatActuallyDisablesVerification` WITHOUT checking the feature flag.
    }

    public void testTrustAllHostnameDependingOnDerivedValue() {
        String enabled = System.getProperty("disableHostnameVerification");
        if (Boolean.parseBoolean(enabled)) {
            HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true); // GOOD, because it depends on a
                                                                                        // feature
            // flag.
        }
    }

    public void testTrustAllHostnameWithExceptions() {
        HostnameVerifier verifier = new HostnameVerifier() {
            @Override
            public boolean verify(String hostname, SSLSession session) {
                try { verify(hostname, session.getPeerCertificates()); } catch (Exception e) { throw new RuntimeException(); }
                return true; // GOOD [but detected as BAD]. The verification of the certificate is done in
                             // another method and
                // in the case of a mismatch, an `Exception` is thrown so the `return true`
                // statement never gets executed.
            }

            // Black-box method that properly verifies the certificate but throws an
            // `Exception` in the case of a mismatch.
            private void verify(String hostname, Certificate[] certs) {
            }
        };
        HttpsURLConnection.setDefaultHostnameVerifier(verifier);
    }

    /**
     * Test the implementation of trusting all hostnames as a variable
     */
    public void testTrustAllHostnameOfVariable() {
        HostnameVerifier verifier = new HostnameVerifier() {
            @Override
            public boolean verify(String hostname, SSLSession session) {
                return true; // BAD, always returns true
            }
        };
        HttpsURLConnection.setDefaultHostnameVerifier(verifier);
    }

    public static final HostnameVerifier ALLOW_ALL_HOSTNAME_VERIFIER = new HostnameVerifier() {
        @Override
        public boolean verify(String hostname, SSLSession session) {
            return true; // BAD, always returns true
        }
    };

    private static class AlwaysTrueVerifier implements HostnameVerifier {
        @Override
        public boolean verify(String hostname, SSLSession session) {
            return true; // BAD, always returns true
        }
    }

    /**
     * Same as testTrustAllHostnameOfAnonymousClass, but with a named class.
     * This is for testing the diff-informed functionality of the query.
     */
    public void testTrustAllHostnameOfNamedClass() {
        HttpsURLConnection.setDefaultHostnameVerifier(new AlwaysTrueVerifier());
    }

}
