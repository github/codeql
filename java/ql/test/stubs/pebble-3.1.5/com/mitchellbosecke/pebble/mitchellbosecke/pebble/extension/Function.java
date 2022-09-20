// Generated automatically from com.mitchellbosecke.pebble.extension.Function for testing purposes

package com.mitchellbosecke.pebble.extension;

import com.mitchellbosecke.pebble.extension.NamedArguments;
import com.mitchellbosecke.pebble.template.EvaluationContext;
import com.mitchellbosecke.pebble.template.PebbleTemplate;
import java.util.Map;

public interface Function extends NamedArguments
{
    Object execute(Map<String, Object> p0, PebbleTemplate p1, EvaluationContext p2, int p3);
}
