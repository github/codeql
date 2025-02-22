public void processData(Socket sock) {
    ObjectInputStream stream = new ObjectInputStream(sock.getInputStream());

    int size = stream.readInt();

    if (size > 4096) {
        throw new IOException("Size too large");
    }

    // GOOD: There is an upper bound on memory consumption.
    byte[] buffer = new byte[size];

    // ...
}