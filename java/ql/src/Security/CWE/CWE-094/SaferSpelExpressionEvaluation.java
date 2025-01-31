public Object evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
      new InputStreamReader(socket.getInputStream()))) {

    String string = reader.readLine();
    ExpressionParser parser = new SpelExpressionParser();
    Expression expression = parser.parseExpression(string); // AVOID: string is controlled by the user
    SimpleEvaluationContext context 
        = SimpleEvaluationContext.forReadWriteDataBinding().build();
    return expression.getValue(context); // OK: Untrusted expressions are evaluated in a restricted context
  }
}