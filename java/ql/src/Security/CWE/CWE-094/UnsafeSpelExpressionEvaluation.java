public Object evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
      new InputStreamReader(socket.getInputStream()))) {

    String string = reader.readLine();
    ExpressionParser parser = new SpelExpressionParser();
    Expression expression = parser.parseExpression(string); // BAD: string is controlled by the user
    return expression.getValue();
  }
}