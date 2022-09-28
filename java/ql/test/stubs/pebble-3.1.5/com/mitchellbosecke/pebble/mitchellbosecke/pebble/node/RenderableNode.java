// Generated automatically from com.mitchellbosecke.pebble.node.RenderableNode for testing purposes

package com.mitchellbosecke.pebble.node;

import com.mitchellbosecke.pebble.node.Node;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public interface RenderableNode extends Node
{
    void render(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2);
}
