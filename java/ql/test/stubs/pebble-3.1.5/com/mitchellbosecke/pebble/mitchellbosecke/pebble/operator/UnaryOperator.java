// Generated automatically from com.mitchellbosecke.pebble.operator.UnaryOperator for testing purposes

package com.mitchellbosecke.pebble.operator;

import com.mitchellbosecke.pebble.node.expression.UnaryExpression;

public interface UnaryOperator
{
    Class<? extends UnaryExpression> getNodeClass();
    String getSymbol();
    int getPrecedence();
}
