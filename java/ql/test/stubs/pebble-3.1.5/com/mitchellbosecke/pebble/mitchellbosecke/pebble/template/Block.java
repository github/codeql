// Generated automatically from com.mitchellbosecke.pebble.template.Block for testing purposes

package com.mitchellbosecke.pebble.template;

import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.io.Writer;

public interface Block
{
    String getName();
    void evaluate(PebbleTemplateImpl p0, Writer p1, EvaluationContextImpl p2);
}
