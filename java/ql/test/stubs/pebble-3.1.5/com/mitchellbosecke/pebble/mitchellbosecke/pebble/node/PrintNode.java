// Generated automatically from com.mitchellbosecke.pebble.node.PrintNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.expression.Expression;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class PrintNode extends AbstractRenderableNode
{
    protected PrintNode() {}
    public Expression<? extends Object> getExpression(){ return null; }
    public PrintNode(Expression<? extends Object> p0, int p1){}
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
    public void setExpression(Expression<? extends Object> p0){}
}
