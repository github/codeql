// Generated automatically from com.mitchellbosecke.pebble.operator.BinaryOperator for testing purposes

package com.mitchellbosecke.pebble.operator;

import com.mitchellbosecke.pebble.node.expression.BinaryExpression;
import com.mitchellbosecke.pebble.operator.Associativity;
import com.mitchellbosecke.pebble.operator.BinaryOperatorType;

public interface BinaryOperator
{
    Associativity getAssociativity();
    BinaryExpression<? extends Object> getInstance();
    BinaryOperatorType getType();
    String getSymbol();
    int getPrecedence();
}
