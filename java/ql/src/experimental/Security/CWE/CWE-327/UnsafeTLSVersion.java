public SSLSocket connect(String host, int port)
        throws NoSuchAlgorithmException, IOException {
    
    SSLContext context = SSLContext.getInstance("SSLv3");
    return (SSLSocket) context.getSocketFactory().createSocket(host, port);
}