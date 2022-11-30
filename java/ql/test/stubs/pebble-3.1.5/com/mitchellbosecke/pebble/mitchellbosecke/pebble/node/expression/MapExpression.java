// Generated automatically from com.mitchellbosecke.pebble.node.expression.MapExpression for testing purposes

package com.mitchellbosecke.pebble.node.expression;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.expression.Expression;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.util.Map;

public class MapExpression implements Expression<Map<? extends Object, ? extends Object>>
{
    protected MapExpression() {}
    public Map<? extends Object, ? extends Object> evaluate(PebbleTemplateImpl p0, EvaluationContextImpl p1){ return null; }
    public MapExpression(Map<Expression<? extends Object>, Expression<? extends Object>> p0, int p1){}
    public MapExpression(int p0){}
    public int getLineNumber(){ return 0; }
    public void accept(NodeVisitor p0){}
}
