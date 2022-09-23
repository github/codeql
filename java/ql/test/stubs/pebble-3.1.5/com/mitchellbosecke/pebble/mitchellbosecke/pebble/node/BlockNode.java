// Generated automatically from com.mitchellbosecke.pebble.node.BlockNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.template.Block;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class BlockNode extends AbstractRenderableNode
{
    protected BlockNode() {}
    public Block getBlock(){ return null; }
    public BlockNode(int p0, String p1){}
    public BlockNode(int p0, String p1, BodyNode p2){}
    public BodyNode getBody(){ return null; }
    public String getName(){ return null; }
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
