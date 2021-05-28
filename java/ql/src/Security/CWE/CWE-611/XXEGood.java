public void disableDTDParse(Socket sock) throws Exception {
  DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
  factory.setFeature("https://apache.org/xml/features/disallow-doctype-decl", true);
  DocumentBuilder builder = factory.newDocumentBuilder();
  builder.parse(sock.getInputStream()); //safe
}
