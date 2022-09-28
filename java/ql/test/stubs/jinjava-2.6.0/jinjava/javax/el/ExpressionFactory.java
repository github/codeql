// Generated automatically from jinjava.javax.el.ExpressionFactory for testing purposes

package jinjava.javax.el;

import java.util.Properties;
import jinjava.javax.el.ELContext;
import jinjava.javax.el.MethodExpression;
import jinjava.javax.el.ValueExpression;

abstract public class ExpressionFactory
{
    public ExpressionFactory(){}
    public abstract MethodExpression createMethodExpression(ELContext p0, String p1, Class<? extends Object> p2, Class<? extends Object>[] p3);
    public abstract Object coerceToType(Object p0, Class<? extends Object> p1);
    public abstract ValueExpression createValueExpression(ELContext p0, String p1, Class<? extends Object> p2);
    public abstract ValueExpression createValueExpression(Object p0, Class<? extends Object> p1);
    public static ExpressionFactory newInstance(){ return null; }
    public static ExpressionFactory newInstance(Properties p0){ return null; }
}
