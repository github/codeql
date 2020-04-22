package javax.el;

public abstract class ExpressionFactory {
  public static ExpressionFactory newInstance() {
    return null;
  }

  public abstract MethodExpression createMethodExpression(ELContext context,
            String expression, Class<?> expectedReturnType,
            Class<?>[] expectedParamTypes);
  
  public abstract ValueExpression createValueExpression(ELContext context,
            String expression, Class<?> expectedType);
}