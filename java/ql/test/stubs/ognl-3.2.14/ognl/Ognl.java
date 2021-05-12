package ognl;

import ognl.enhance.ExpressionAccessor;

import java.util.*;

public abstract class Ognl {
  public static Object parseExpression(String expression) throws OgnlException {
    return new Object();
  }

  public static Object getValue(Object tree, Map context, Object root) throws OgnlException {
    return new Object();
  }

  public static Object getValue(ExpressionAccessor accessor, OgnlContext context, Object root) throws OgnlException {
    return new Object();
  }

  public static void setValue(Object tree, Object root, Object value) throws OgnlException {}

  public static void setValue(ExpressionAccessor accessor, OgnlContext context, Object root, Object value) throws OgnlException {}

  public static Node compileExpression(OgnlContext context, Object root, String expression)
            throws Exception {
    return null;
  }

  public static Object getValue(String expression, Object root) throws OgnlException {
    return new Object();
  }

  public static void setValue(String expression, Object root, Object value) throws OgnlException {}
}
