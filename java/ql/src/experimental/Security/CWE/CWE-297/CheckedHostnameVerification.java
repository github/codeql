SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(host, port);
socket.startHandshake();
boolean successful = verifier.verify(host, socket.getSession());
if (!successful) {
    socket.close();
    throw new SSLException("Oops! Hostname verification failed!");
}
return socket;