// Generated automatically from jinjava.javax.el.MethodExpression for testing purposes

package jinjava.javax.el;

import jinjava.javax.el.ELContext;
import jinjava.javax.el.Expression;
import jinjava.javax.el.MethodInfo;

abstract public class MethodExpression extends Expression
{
    public MethodExpression(){}
    public abstract MethodInfo getMethodInfo(ELContext p0);
    public abstract Object invoke(ELContext p0, Object[] p1);
    public boolean isParmetersProvided(){ return false; }
}
