public MyObject deserialize(Socket sock) {
  try(DataInputStream in = new DataInputStream(sock.getInputStream())) {
    return new MyObject(in.readInt());
  }
}
