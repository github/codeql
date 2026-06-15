public Object evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
      new InputStreamReader(socket.getInputStream()))) {

    String string = reader.readLine();
    ExpressionParser parser = new SpelExpressionParser();
    // BAD: string is controlled by the user
    Expression expression = parser.parseExpression(string);
    return expression.getValue();
  }
}