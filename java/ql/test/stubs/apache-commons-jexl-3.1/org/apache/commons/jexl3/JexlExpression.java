package org.apache.commons.jexl3;

import java.util.concurrent.Callable;

public interface JexlExpression {
    Object evaluate(JexlContext context);
    Callable<Object> callable(JexlContext context);
}