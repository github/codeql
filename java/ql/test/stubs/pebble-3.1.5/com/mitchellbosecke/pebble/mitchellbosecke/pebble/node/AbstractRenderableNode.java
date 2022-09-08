// Generated automatically from com.mitchellbosecke.pebble.node.AbstractRenderableNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.RenderableNode;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

abstract public class AbstractRenderableNode implements RenderableNode
{
    public AbstractRenderableNode(){}
    public AbstractRenderableNode(int p0){}
    public abstract void accept(NodeVisitor p0);
    public abstract void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2);
    public int getLineNumber(){ return 0; }
    public void setLineNumber(int p0){}
}
