// Generated automatically from com.mitchellbosecke.pebble.node.RootNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class RootNode extends AbstractRenderableNode
{
    protected RootNode() {}
    public BodyNode getBody(){ return null; }
    public RootNode(BodyNode p0){}
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
