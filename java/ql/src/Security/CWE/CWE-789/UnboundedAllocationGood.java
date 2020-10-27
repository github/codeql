public void processData(Socket sock) {
    InputStream iStream = sock.getInputStream();
    ObjectInpuStream oiStream = new ObjectInputStream(iStream);

    int size = oiStream.readInt();

    if (size > 4096) {
        throw new IllegalArgumentException("Size too large");
    }

    // GOOD: There is an upper bound on memory consumption.
    byte[] buffer = new byte[size];

    oiStream.readFully(buffer);
}