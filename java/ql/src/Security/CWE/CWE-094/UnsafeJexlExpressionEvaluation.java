public void evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
        new InputStreamReader(socket.getInputStream()))) {
    
    String input = reader.readLine();
    JexlEngine jexl = new JexlBuilder().create();
    JexlExpression expression = jexl.createExpression(input); // BAD: input is controlled by the user
    JexlContext context = new MapContext();
    expression.evaluate(context);
  }
}