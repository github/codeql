// Open SSLSocket directly to example.org.
SocketFactory sf = SSLSocketFactory.getDefault();
SSLSocket socket = (SSLSocket) sf.createSocket("example.org", 443);
HostnameVerifier hv = HttpsURLConnection.getDefaultHostnameVerifier();
SSLSession s = socket.getSession();

// Verify that the certificate matches the hostname.
if (!hv.verify(s.getPeerHost(), s)) { // GOOD
    // We use the default hostname verifier from Android to verify that the
    // certificate matches.
    throw new SSLHandshakeException("Expected <" + s.getPeerHost() + ">, but " + "found " + s.getPeerPrincipal());
}

// Hostname verification has been performed and we can proceed.