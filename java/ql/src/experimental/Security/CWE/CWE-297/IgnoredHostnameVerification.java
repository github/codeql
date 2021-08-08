SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(host, port);
socket.startHandshake();
verifier.verify(host, socket.getSession());
return socket;