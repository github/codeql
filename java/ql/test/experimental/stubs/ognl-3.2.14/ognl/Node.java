package ognl;

public interface Node extends JavaSource {
  public Object getValue(OgnlContext context, Object source) throws OgnlException;
  public void setValue(OgnlContext context, Object target, Object value) throws OgnlException;
}
