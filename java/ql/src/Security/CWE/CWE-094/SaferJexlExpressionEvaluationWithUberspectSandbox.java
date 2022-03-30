public void evaluate(Socket socket) throws IOException {
  try (BufferedReader reader = new BufferedReader(
        new InputStreamReader(socket.getInputStream()))) {
    
    JexlUberspect sandbox = new JexlUberspectSandbox();
    JexlEngine jexl = new JexlBuilder().uberspect(sandbox).create();
      
    String input = reader.readLine();
    JexlExpression expression = jexl.createExpression(input);
    JexlContext context = new MapContext();
    expression.evaluate(context);
  }

  private static class JexlUberspectSandbox implements JexlUberspect {

    private static final List<String> ALLOWED_CLASSES =
              Arrays.asList("java.lang.Math", "java.util.Random");

    private final JexlUberspect uberspect = new JexlBuilder().create().getUberspect();

    private void checkAccess(Object obj) {
      if (!ALLOWED_CLASSES.contains(obj.getClass().getCanonicalName())) {
        throw new AccessControlException("Not allowed");
      }
    }

    @Override
    public JexlMethod getMethod(Object obj, String method, Object... args) {
      checkAccess(obj);
      return uberspect.getMethod(obj, method, args);
    }

    @Override
    public List<PropertyResolver> getResolvers(JexlOperator op, Object obj) {
      checkAccess(obj);
      return uberspect.getResolvers(op, obj);
    }

    @Override
    public void setClassLoader(ClassLoader loader) {
      uberspect.setClassLoader(loader);
    }

    @Override
    public int getVersion() {
      return uberspect.getVersion();
    }

    @Override
    public JexlMethod getConstructor(Object obj, Object... args) {
      checkAccess(obj);
      return uberspect.getConstructor(obj, args);
    }

    @Override
    public JexlPropertyGet getPropertyGet(Object obj, Object identifier) {
      checkAccess(obj);
      return uberspect.getPropertyGet(obj, identifier);
    }

    @Override
    public JexlPropertyGet getPropertyGet(List<PropertyResolver> resolvers, Object obj, Object identifier) {
      checkAccess(obj);
      return uberspect.getPropertyGet(resolvers, obj, identifier);
    }

    @Override
    public JexlPropertySet getPropertySet(Object obj, Object identifier, Object arg) {
      checkAccess(obj);
      return uberspect.getPropertySet(obj, identifier, arg);
    }

    @Override
    public JexlPropertySet getPropertySet(List<PropertyResolver> resolvers, Object obj, Object identifier, Object arg) {
      checkAccess(obj);
      return uberspect.getPropertySet(resolvers, obj, identifier, arg);
    }

    @Override
    public Iterator<?> getIterator(Object obj) {
      checkAccess(obj);
      return uberspect.getIterator(obj);
    }

    @Override
    public JexlArithmetic.Uberspect getArithmetic(JexlArithmetic arithmetic) {
      return uberspect.getArithmetic(arithmetic);
    } 
  }
}