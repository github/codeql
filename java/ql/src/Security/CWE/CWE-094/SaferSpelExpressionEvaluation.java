public Object evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
      new InputStreamReader(socket.getInputStream()))) {

    String string = reader.readLine();
    ExpressionParser parser = new SpelExpressionParser();
    // AVOID: string is controlled by the user
    Expression expression = parser.parseExpression(string);
    SimpleEvaluationContext context 
        = SimpleEvaluationContext.forReadWriteDataBinding().build();
    // OK: Untrusted expressions are evaluated in a restricted context
    return expression.getValue(context);
  }
}