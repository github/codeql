// GOOD: Certificate pinning implemented via okhttp3.CertificatePinner 
CertificatePinner certificatePinner = new CertificatePinner.Builder()
    .add("example.com", "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")
    .build();
OkHttpClient client = new OkHttpClient.Builder()
    .certificatePinner(certificatePinner)
    .build();

client.newCall(new Request.Builder().url("https://example.com").build()).execute();



// GOOD: Certificate pinning implemented via a TrustManager
KeyStore keyStore = KeyStore.getInstance("BKS");
keyStore.load(resources.openRawResource(R.raw.cert), null);

TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
tmf.init(keyStore);

SSLContext sslContext = SSLContext.getInstance("TLS");
sslContext.init(null, tmf.getTrustManagers(), null);

URL url = new URL("http://www.example.com/");
HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection(); 

urlConnection.setSSLSocketFactory(sslContext.getSocketFactory());