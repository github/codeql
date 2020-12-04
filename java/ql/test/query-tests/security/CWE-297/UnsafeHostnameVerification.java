import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

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
		// and not accross function calls. This is considerer GOOD because the call to
		// `functionThatActuallyDisablesVerification` is guarded by a feature flag in
		// `testGuardedByFlagAccrossCalls`.
		// Although this is not ideal as another function could directly call
		// `functionThatActuallyDisablesVerification` WITHOUT checking the feature flag.
	}

	public void testTrustAllHostnameDependingOnDerivedValue() {
		String enabled = System.getProperty("disableHostnameVerification");
		if (Boolean.parseBoolean(enabled)) {
			HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);  // GOOD [but detected as BAD].
			                                                                   // This is GOOD, because it depends on a feature
			                                                                   // flag, but this is not detected by the query.
		}
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
}

