public static void main(String[] args) {

	{
		HostnameVerifier verifier = new HostnameVerifier() {
			@Override
			public boolean verify(String hostname, SSLSession session) {
				return true; // BAD: accept even if the hostname doesn't match
			}
		};
		HttpsURLConnection.setDefaultHostnameVerifier(verifier);
	}

	{
		HostnameVerifier verifier = new HostnameVerifier() {
			@Override
			public boolean verify(String hostname, SSLSession session) {
				try { // GOOD: verify the certificate
					Certificate[] certs = session.getPeerCertificates();
					X509Certificate x509 = (X509Certificate) certs[0];
					check(new String[]{host}, x509);
					return true;
				} catch (SSLException e) {
					return false;
				}
			}
		};
		HttpsURLConnection.setDefaultHostnameVerifier(verifier);
	}

}