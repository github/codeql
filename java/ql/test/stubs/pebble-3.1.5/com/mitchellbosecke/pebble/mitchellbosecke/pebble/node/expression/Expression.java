// Generated automatically from com.mitchellbosecke.pebble.node.expression.Expression for testing purposes

package com.mitchellbosecke.pebble.node.expression;

import com.mitchellbosecke.pebble.node.Node;
import com.mitchellbosecke.pebble.template.EvaluationContextImpl;
import com.mitchellbosecke.pebble.template.PebbleTemplateImpl;

public interface Expression<T> extends Node
{
    T evaluate(PebbleTemplateImpl p0, EvaluationContextImpl p1);
    int getLineNumber();
}
