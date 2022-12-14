// Generated automatically from com.mitchellbosecke.pebble.node.MacroNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.AbstractRenderableNode;
import com.mitchellbosecke.pebble.node.ArgumentsNode;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.Macro;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public class MacroNode extends AbstractRenderableNode
{
    protected MacroNode() {}
    public ArgumentsNode getArgs(){ return null; }
    public BodyNode getBody(){ return null; }
    public Macro getMacro(){ return null; }
    public MacroNode(String p0, ArgumentsNode p1, BodyNode p2){}
    public String getName(){ return null; }
    public void accept(NodeVisitor p0){}
    public void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2){}
}
