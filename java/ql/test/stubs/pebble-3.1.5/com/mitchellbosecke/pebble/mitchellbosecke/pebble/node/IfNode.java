// Generated automatically from com.mitchellbosecke.pebble.node.IfNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.node.expression.Expression;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import com.mitchellbosecke.pebble.utils.Pair;
import java.io.Writer;
import java.util.List;

public class IfNode extends AbstractRenderableNode
{
    protected IfNode() {}
    public BodyNode getElseBody(){ return null; }
    public IfNode(int p0, List<Pair<Expression<? extends Object>, BodyNode>> p1){}
    public IfNode(int p0, List<Pair<Expression<? extends Object>, BodyNode>> p1, BodyNode p2){}
    public List<Pair<Expression<? extends Object>, BodyNode>> getConditionsWithBodies(){ return null; }
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
