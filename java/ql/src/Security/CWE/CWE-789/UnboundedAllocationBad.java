public void processData(Socket sock) {
    InputStream iStream = sock.getInputStream();
    ObjectInpuStream oiStream = new ObjectInputStream(iStream);

    int size = oiStream.readInt();
    // BAD: A user-controlled amount of memory is alocated
    byte[] buffer = new byte[size];

    oiStream.readFully(buffer);
}