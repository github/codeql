// Generated automatically from com.mitchellbosecke.pebble.node.SetNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.expression.Expression;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class SetNode extends AbstractRenderableNode
{
    protected SetNode() {}
    public Expression<? extends Object> getValue(){ return null; }
    public SetNode(int p0, String p1, Expression<? extends Object> p2){}
    public String getName(){ return null; }
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
