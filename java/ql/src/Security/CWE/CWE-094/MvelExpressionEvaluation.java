public void evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
    new InputStreamReader(socket.getInputStream()))) {
  
    String expression = reader.readLine();
    // BAD: the user-provided expression is directly evaluated
    MVEL.eval(expression);
  }
}

public void safeEvaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
    new InputStreamReader(socket.getInputStream()))) {
  
    String expression = reader.readLine();
    // GOOD: the user-provided expression is validated before evaluation
    validateExpression(expression);
    MVEL.eval(expression);
  }
}

private void validateExpression(String expression) {
  // Validate that the expression does not contain unexpected code.
  // For instance, this can be done with allow-lists or deny-lists of code patterns.
}