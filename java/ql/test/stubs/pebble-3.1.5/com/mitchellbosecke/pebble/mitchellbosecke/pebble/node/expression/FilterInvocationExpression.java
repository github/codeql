// Generated automatically from com.mitchellbosecke.pebble.node.expression.FilterInvocationExpression for testing purposes

package com.mitchellbosecke.pebble.node.expression;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.ArgumentsNode;
import com.mitchellbosecke.pebble.node.expression.Expression;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;

public class FilterInvocationExpression implements Expression<Object>
{
    protected FilterInvocationExpression() {}
    public ArgumentsNode getArgs(){ return null; }
    public FilterInvocationExpression(String p0, ArgumentsNode p1, int p2){}
    public Object evaluate(PebbleTemplateImpl p0, EvaluationContextImpl p1){ return null; }
    public String getFilterName(){ return null; }
    public int getLineNumber(){ return 0; }
    public void accept(NodeVisitor p0){}
}
