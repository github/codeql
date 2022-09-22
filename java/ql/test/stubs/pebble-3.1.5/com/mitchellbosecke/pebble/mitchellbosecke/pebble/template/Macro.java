// Generated automatically from com.mitchellbosecke.pebble.template.Macro for testing purposes

package com.mitchellbosecke.pebble.template;

import com.mitchellbosecke.pebble.extension.NamedArguments;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;
import java.util.Map;

public interface Macro extends NamedArguments
{
    String call(PebbleTemplateImpl p0, EvaluationContextImpl p1, Map<String, Object> p2);
    String getName();
}
