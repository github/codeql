// Generated automatically from com.mitchellbosecke.pebble.node.ArgumentsNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.extension.NamedArguments;
import com.mitchellbosecke.pebble.extension.NodeVisitor;
import com.mitchellbosecke.pebble.node.NamedArgumentNode;
import com.mitchellbosecke.pebble.node.Node;
import com.mitchellbosecke.pebble.node.PositionalArgumentNode;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.util.List;
import java.util.Map;

public class ArgumentsNode implements Node
{
    protected ArgumentsNode() {}
    public ArgumentsNode(List<PositionalArgumentNode> p0, List<NamedArgumentNode> p1, int p2){}
    public List<NamedArgumentNode> getNamedArgs(){ return null; }
    public List<PositionalArgumentNode> getPositionalArgs(){ return null; }
    public Map<String, Object> getArgumentMap(PebbleTemplateImpl p0, EvaluationContextImpl p1, NamedArguments p2){ return null; }
    public String toString(){ return null; }
    public void accept(NodeVisitor p0){}
}
