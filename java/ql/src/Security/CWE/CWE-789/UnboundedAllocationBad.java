public void processData(Socket sock) {
    ObjectInputStream stream = new ObjectInputStream(sock.getInputStream());

    int size = stream.readInt();
    // BAD: A user-controlled amount of memory is alocated
    byte[] buffer = new byte[size];

    // ...
}