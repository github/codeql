// Generated automatically from com.mitchellbosecke.pebble.node.expression.BinaryExpression for testing purposes

package com.mitchellbosecke.pebble.node.expression;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.expression.Expression;

abstract public class BinaryExpression<T> implements Expression<T>
{
    public BinaryExpression(){}
    public BinaryExpression(Expression<? extends Object> p0, Expression<? extends Object> p1){}
    public Expression<? extends Object> getLeftExpression(){ return null; }
    public Expression<? extends Object> getRightExpression(){ return null; }
    public int getLineNumber(){ return 0; }
    public void accept(NodeVisitor p0){}
    public void setLeft(Expression<? extends Object> p0){}
    public void setLineNumber(int p0){}
    public void setRight(Expression<? extends Object> p0){}
}
