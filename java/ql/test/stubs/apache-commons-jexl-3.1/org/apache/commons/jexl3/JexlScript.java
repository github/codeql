package org.apache.commons.jexl3;

import java.util.concurrent.Callable;

public interface JexlScript {

    Object execute(JexlContext context);
    Object execute(JexlContext context, Object... args);
    Callable<Object> callable(JexlContext context);
    Callable<Object> callable(JexlContext context, Object... args);
}
