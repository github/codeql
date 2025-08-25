package com.example;

import java.net.URL;
import java.net.URLConnection;
import java.security.KeyStore;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import android.content.res.Resources;

class Test {
    void test1(Resources resources) throws Exception {
        KeyStore keyStore = KeyStore.getInstance("BKS");
        keyStore.load(resources.openRawResource(R.raw.cert), null);

        TrustManagerFactory tmf =
                TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(keyStore);

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, tmf.getTrustManagers(), null);

        URL url = new URL("http://www.example.com/");
        HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection();

        urlConnection.setSSLSocketFactory(sslContext.getSocketFactory());
    }

    void test2() throws Exception {
        URL url = new URL("http://www.example.com/");
        HttpsURLConnection urlConnection = (HttpsURLConnection) url.openConnection(); // $hasNoTrustedResult
    }
}
