package com.example;

import java.net.URL;
import java.net.URLConnection;
import java.io.InputStream;
import java.security.KeyStore;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import android.content.res.Resources;

class Test {
    void init(Resources resources) throws Exception {
        KeyStore keyStore = KeyStore.getInstance("BKS");
        keyStore.load(resources.openRawResource(R.raw.cert), null);

        TrustManagerFactory tmf =
                TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(keyStore);

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, tmf.getTrustManagers(), null);

        HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());
    }

    URLConnection test1() throws Exception {
        URL url = new URL("http://www.example.com/");
        return url.openConnection();
    }

    InputStream test2() throws Exception {
        URL url = new URL("http://www.example.com/");
        return url.openStream();
    }

    InputStream test3() throws Exception {
        URL url = new URL("classpath:example/directory/test.class");
        return url.openStream();
    }

    InputStream test4() throws Exception {
        URL url = new URL("file:///example/file");
        return url.openStream();
    }

    InputStream test5() throws Exception {
        URL url = new URL("jar:file:///C:/example/test.jar!/test.xml");
        return url.openStream();
    }
}
