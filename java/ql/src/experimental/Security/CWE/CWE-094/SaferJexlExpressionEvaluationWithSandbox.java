public void evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
        new InputStreamReader(socket.getInputStream()))) {
    
    JexlSandbox onlyMath = new JexlSandbox(false);
    onlyMath.white("java.lang.Math");
    JexlEngine jexl = new JexlBuilder().sandbox(onlyMath).create();
      
    String input = reader.readLine();
    JexlExpression expression = jexl.createExpression(input);
    JexlContext context = new MapContext();
    expression.evaluate(context);
  }
}