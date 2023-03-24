// Generated automatically from com.mitchellbosecke.pebble.node.ForNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.node.expression.Expression;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class ForNode extends AbstractRenderableNode
{
    protected ForNode() {}
    public BodyNode getBody(){ return null; }
    public BodyNode getElseBody(){ return null; }
    public Expression<? extends Object> getIterable(){ return null; }
    public ForNode(int p0, String p1, Expression<? extends Object> p2, BodyNode p3, BodyNode p4){}
    public String getIterationVariable(){ return null; }
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
