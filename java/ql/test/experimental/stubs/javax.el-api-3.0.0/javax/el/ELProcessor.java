package javax.el;

public class ELProcessor {
  public Object eval(String expression) {
    return new Object();
  }

  public Object getValue(String expression, Class<?> expectedType) {
    return new Object();
  }

  public void setValue(String expression, Object value) {}
}