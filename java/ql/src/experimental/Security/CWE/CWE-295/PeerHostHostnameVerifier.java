HostnameVerifier hostnameVerifier = new HostnameVerifier() {
    @Override
    public boolean verify(String hostname, SSLSession session) {
        return hostname.equals(session.getPeerHost()); // BAD, getPeerHost() is not authenticated
        // and will always be equal to the hostname, therefore trusting ALL hostnames
    }
};