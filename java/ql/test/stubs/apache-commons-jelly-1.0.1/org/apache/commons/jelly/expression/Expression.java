// Generated automatically from org.apache.commons.jelly.expression.Expression for testing purposes

package org.apache.commons.jelly.expression;

import java.util.Iterator;
import org.apache.commons.jelly.JellyContext;

public interface Expression
{
    Iterator evaluateAsIterator(JellyContext p0);
    Object evaluate(JellyContext p0);
    Object evaluateRecurse(JellyContext p0);
    String evaluateAsString(JellyContext p0);
    String getExpressionText();
    boolean evaluateAsBoolean(JellyContext p0);
}
