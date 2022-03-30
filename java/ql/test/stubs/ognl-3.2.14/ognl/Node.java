package ognl;

import ognl.enhance.ExpressionAccessor;

public interface Node extends JavaSource {
  public Object getValue(OgnlContext context, Object source) throws OgnlException;
  public void setValue(OgnlContext context, Object target, Object value) throws OgnlException;
  ExpressionAccessor getAccessor();
}
