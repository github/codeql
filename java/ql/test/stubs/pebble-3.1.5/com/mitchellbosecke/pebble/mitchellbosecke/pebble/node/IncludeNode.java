// Generated automatically from com.mitchellbosecke.pebble.node.IncludeNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.expression.Expression;
import com.mitchellbosecke.pebble.node.expression.MapExpression;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class IncludeNode extends AbstractRenderableNode
{
    protected IncludeNode() {}
    public Expression<? extends Object> getIncludeExpression(){ return null; }
    public IncludeNode(int p0, Expression<? extends Object> p1, MapExpression p2){}
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
