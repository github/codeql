public static void main(String[] args) {
	{
		X509TrustManager trustAllCertManager = new X509TrustManager() {
			@Override
			public void checkClientTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
			}

			@Override
			public void checkServerTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
				// BAD: trust any server cert
			}

			@Override
			public X509Certificate[] getAcceptedIssuers() {
				return null; //BAD: doesn't check cert issuer
			}
		};
	}

	{
		X509TrustManager trustCertManager = new X509TrustManager() {
			@Override
			public void checkClientTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
			}

			@Override
			public void checkServerTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
				pkixTrustManager.checkServerTrusted(chain, authType); //GOOD: validate the server cert
			}

			@Override
			public X509Certificate[] getAcceptedIssuers() {
				return new X509Certificate[0]; //GOOD: Validate the cert issuer
			}
		};
	}
}