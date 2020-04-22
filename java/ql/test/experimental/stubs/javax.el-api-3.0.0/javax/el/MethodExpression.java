package javax.el;

public abstract class MethodExpression extends Expression {
  public abstract Object invoke(ELContext context, Object[] params);
}