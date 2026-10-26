package org.apache.commons.jexl2;

public interface Expression {
    Object evaluate(JexlContext var1);
    String getExpression();
    String dump();
}
