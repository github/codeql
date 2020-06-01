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