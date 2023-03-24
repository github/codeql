// Generated automatically from jinjava.javax.el.ValueExpression for testing purposes

package jinjava.javax.el;

import jinjava.javax.el.ELContext;
import jinjava.javax.el.Expression;
import jinjava.javax.el.ValueReference;

abstract public class ValueExpression extends Expression
{
    public ValueExpression(){}
    public ValueReference getValueReference(ELContext p0){ return null; }
    public abstract Class<? extends Object> getExpectedType();
    public abstract Class<? extends Object> getType(ELContext p0);
    public abstract Object getValue(ELContext p0);
    public abstract boolean isReadOnly(ELContext p0);
    public abstract void setValue(ELContext p0, Object p1);
}
