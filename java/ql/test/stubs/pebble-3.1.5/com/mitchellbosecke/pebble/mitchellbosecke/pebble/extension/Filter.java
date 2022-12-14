// Generated automatically from com.mitchellbosecke.pebble.extension.Filter for testing purposes

package com.mitchellbosecke.pebble.extension;

import com.mitchellbosecke.pebble.extension.NamedArguments;
import com.mitchellbosecke.pebble.template.EvaluationContext;
import com.mitchellbosecke.pebble.template.PebbleTemplate;
import java.util.Map;

public interface Filter extends NamedArguments
{
    Object apply(Object p0, Map<String, Object> p1, PebbleTemplate p2, EvaluationContext p3, int p4);
}
