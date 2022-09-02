class Bad extends WebViewClient {
    // BAD: All certificates are trusted.
    public void onReceivedSslError (WebView view, SslErrorHandler handler, SslError error) { // $hasResult
        handler.proceed(); 
    }
}

class Good extends WebViewClient {
    PublicKey myPubKey = ...;

    // GOOD: Only certificates signed by a certain public key are trusted.
    public void onReceivedSslError (WebView view, SslErrorHandler handler, SslError error) { // $hasResult
        try {
            X509Certificate cert = error.getCertificate().getX509Certificate();
            cert.verify(this.myPubKey);
            handler.proceed();
        }
        catch (CertificateException|NoSuchAlgorithmException|InvalidKeyException|NoSuchProviderException|SignatureException e) {
            handler.cancel();
        }
    }    
}