// Open SSLSocket directly to example.org.
SocketFactory sf = SSLSocketFactory.getDefault();
SSLSocket socket = (SSLSocket) sf.createSocket("example.org", 443);
SSLParameters sslParams = new SSLParameters();
sslParams.setEndpointIdentificationAlgorithm("HTTPS"); // GOOD, enable hostname verification using the `HTTPS`
                                                        // verification algorithm.
socket.setSSLParameters(sslParams);

// Hostname verification has been performed and we can proceed.