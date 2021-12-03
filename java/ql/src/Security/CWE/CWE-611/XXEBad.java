public void parse(Socket sock) throws Exception {
  DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
  DocumentBuilder builder = factory.newDocumentBuilder();
  builder.parse(sock.getInputStream()); //unsafe
}
