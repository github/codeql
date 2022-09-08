// Generated automatically from com.mitchellbosecke.pebble.node.BodyNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.RenderableNode;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;
import java.util.List;

public class BodyNode extends AbstractRenderableNode
{
    protected BodyNode() {}
    public BodyNode(int p0, List<RenderableNode> p1){}
    public List<RenderableNode> getChildren(){ return null; }
    public boolean isOnlyRenderInheritanceSafeNodes(){ return false; }
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
    public void setOnlyRenderInheritanceSafeNodes(boolean p0){}
}
