import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;
import javax.net.ssl.HttpsURLConnection;

public class IncorrectHostnameVerifier {
	HostnameVerifier peerHostHostnameVerifier = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			return hostname.equals(session.getPeerHost()); // BAD, getPeerHost() is not authenticated and will always be
															// equal to the hostname, therefore trusting ALL hostnames.
		}
	};

	HostnameVerifier peerHostHostnameVerifier2 = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			String peerHostname = session.getPeerHost();
			return hostname.equals(peerHostname); // BAD, getPeerHost() is not authenticated and will always be equal to
													// the hostname, therefore trusting ALL hostnames.
		}
	};

	HostnameVerifier localHostHostnameVerifier = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			if (hostname.equals("localhost")) { // BAD, does not verify the certificate. In theory traffic to
												// "localhost" should never leave the host. In practice this may not
												// always be the case due to misconfigurations.
				return true;
			} else if (hostname.equals("127.0.0.1")) { // BAD, does not verify the certificate [Debatable Security
														// Impact]. "127.0.0.1" is the IPv4 loopback adress and traffic
														// MUST never leave the host. So this SHOULD be safe, but
														// nevertheless it would be better to use a proper self-signed
														// certificate.
				return true;
			} else if (hostname.equals("::1")) { // BAD, does not verify the certificate [Debatable Security Impact].
													// "::1" is the IPv6 loopback adress and traffic MUST never leave
													// the host. So this SHOULD be safe, but nevertheless it would be
													// better to use a proper self-signed certificate.
				return true;
			}
			return false;

		}
	};

	HostnameVerifier delegatingHostnameVerifier = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			HostnameVerifier verifier = HttpsURLConnection.getDefaultHostnameVerifier();
			if (hostname.equals("example.com")) {
				return verifier.verify("example.org", session); // "GOOD-ISH", if and only if this holds:
				// We want to make a connection to `https://example.com`, but the webserver is
				// misconfigured and wrongly returns the certificate for `https://example.org`.
				// IF we control BOTH example.com and example.org we accept an certificate for
				// `example.org` as valid for `example.com`.
				// NOTE: It's STRONGLY suggested to fix the certificate problem instead.
				// NOTE: This will only work on Android, on (OpenJDK) Java the default
				// `HostnameVerifier` always returns false!
			}
			return false;
		}
	};

	HostnameVerifier externalMethodHostnameVerifier = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			return checkHostname(hostname); // BAD [NOT DETECTED], only the implementation of `verify` method is
											// checked. If the `verify` method calls other methods we can not reason
											// about them. A simple implementation would be to detect that the external
											// method only checks `hostname` and not a value derived from `session`.
		}

		private boolean checkHostname(String hostname) {
			return hostname.equals("example.com"); // BAD [NOT DETECTED], does not verify the certificate.
		}
	};

	HostnameVerifier externalMethodHostnameVerifier2 = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			return check(hostname, session); // BAD [NOT DETECTED], only the implementation of the `verify` method is
												// checked. If the `verify` method calls other methods we can not reason
												// about them. The simple implementation from above
												// (`externalMethodHostnameVerifier`) (if implemented) should not detect
												// this.
		}

		private boolean check(String hostname, SSLSession session) {
			return hostname.equals("example.com"); // BAD [NOT DETECTED], does not verify the certificate.
		}
	};

	HostnameVerifier hostSpecificHostnameVerifier = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			return hostname.equals("host.example.org"); // BAD, does not verify the certificate for `host.example.org`.
		}
	};
}
