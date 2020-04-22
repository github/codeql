package javax.el;

public abstract class ValueExpression extends Expression {
  public abstract Object getValue(ELContext context);

  public abstract void setValue(ELContext context, Object value);
}