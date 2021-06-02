public void evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
    new InputStreamReader(socket.getInputStream()))) {
  
    String expression = reader.readLine();
    MVEL.eval(expression);
  }
}