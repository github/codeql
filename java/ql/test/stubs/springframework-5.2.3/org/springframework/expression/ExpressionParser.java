package org.springframework.expression;

public interface ExpressionParser {

    Expression parseExpression(String string);
}