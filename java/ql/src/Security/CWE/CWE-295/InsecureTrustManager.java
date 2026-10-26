public static void main(String[] args) throws Exception {
    {
        class InsecureTrustManager implements X509TrustManager {
            @Override
            public X509Certificate[] getAcceptedIssuers() {
                return null;
            }

            @Override
            public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                // BAD: Does not verify the certificate chain, allowing any certificate.
            }

            @Override
            public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {

            }
        }
        SSLContext context = SSLContext.getInstance("TLS");
        TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
        context.init(null, trustManager, null);
    }
    {
        SSLContext context = SSLContext.getInstance("TLS");
        File certificateFile = new File("path/to/self-signed-certificate");
        // Create a `KeyStore` with default type
        KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
        // `keyStore` is initially empty
        keyStore.load(null, null);
        X509Certificate generatedCertificate;
        try (InputStream cert = new FileInputStream(certificateFile)) {
            generatedCertificate = (X509Certificate) CertificateFactory.getInstance("X509")
                    .generateCertificate(cert);
        }
        // Add the self-signed certificate to the key store
        keyStore.setCertificateEntry(certificateFile.getName(), generatedCertificate);
        // Get default `TrustManagerFactory`
        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        // Use it with our key store that trusts our self-signed certificate
        tmf.init(keyStore);
        TrustManager[] trustManagers = tmf.getTrustManagers();
        context.init(null, trustManagers, null);
        // GOOD, we are not using a custom `TrustManager` but instead have
        // added the self-signed certificate we want to trust to the key
        // store. Note, the `trustManagers` will **only** trust this one
        // certificate.
        
        URL url = new URL("https://self-signed.badssl.com/");
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setSSLSocketFactory(context.getSocketFactory());
    }
}
