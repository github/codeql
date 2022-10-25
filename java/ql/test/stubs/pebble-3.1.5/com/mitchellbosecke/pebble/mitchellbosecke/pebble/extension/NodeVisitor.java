// Generated automatically from com.mitchellbosecke.pebble.extension.NodeVisitor for testing purposes

package com.mitchellbosecke.pebble.extension;

import com.mitchellbosecke.pebble.node.ArgumentsNode;
import com.mitchellbosecke.pebble.node.AutoEscapeNode;
import com.mitchellbosecke.pebble.node.BlockNode;
import com.mitchellbosecke.pebble.node.BodyNode;
import com.mitchellbosecke.pebble.node.ExtendsNode;
import com.mitchellbosecke.pebble.node.FlushNode;
import com.mitchellbosecke.pebble.node.ForNode;
import com.mitchellbosecke.pebble.node.IfNode;
import com.mitchellbosecke.pebble.node.ImportNode;
import com.mitchellbosecke.pebble.node.IncludeNode;
import com.mitchellbosecke.pebble.node.MacroNode;
import com.mitchellbosecke.pebble.node.NamedArgumentNode;
import com.mitchellbosecke.pebble.node.Node;
import com.mitchellbosecke.pebble.node.ParallelNode;
import com.mitchellbosecke.pebble.node.PositionalArgumentNode;
import com.mitchellbosecke.pebble.node.PrintNode;
import com.mitchellbosecke.pebble.node.RootNode;
import com.mitchellbosecke.pebble.node.SetNode;
import com.mitchellbosecke.pebble.node.TextNode;

public interface NodeVisitor
{
    void visit(ArgumentsNode p0);
    void visit(AutoEscapeNode p0);
    void visit(BlockNode p0);
    void visit(BodyNode p0);
    void visit(ExtendsNode p0);
    void visit(FlushNode p0);
    void visit(ForNode p0);
    void visit(IfNode p0);
    void visit(ImportNode p0);
    void visit(IncludeNode p0);
    void visit(MacroNode p0);
    void visit(NamedArgumentNode p0);
    void visit(Node p0);
    void visit(ParallelNode p0);
    void visit(PositionalArgumentNode p0);
    void visit(PrintNode p0);
    void visit(RootNode p0);
    void visit(SetNode p0);
    void visit(TextNode p0);
}
