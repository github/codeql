// Generated automatically from com.mitchellbosecke.pebble.node.expression.UnaryExpression for testing purposes

package com.mitchellbosecke.pebble.node.expression;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.expression.Expression;

abstract public class UnaryExpression implements Expression<Object>
{
    public Expression<? extends Object> getChildExpression(){ return null; }
    public UnaryExpression(){}
    public int getLineNumber(){ return 0; }
    public void accept(NodeVisitor p0){}
    public void setChildExpression(Expression<? extends Object> p0){}
    public void setLineNumber(int p0){}
}
