// Generated automatically from com.mitchellbosecke.pebble.node.AutoEscapeNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class AutoEscapeNode extends AbstractRenderableNode
{
    protected AutoEscapeNode() {}
    public AutoEscapeNode(int p0, BodyNode p1, boolean p2, String p3){}
    public BodyNode getBody(){ return null; }
    public String getStrategy(){ return null; }
    public boolean isActive(){ return false; }
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
