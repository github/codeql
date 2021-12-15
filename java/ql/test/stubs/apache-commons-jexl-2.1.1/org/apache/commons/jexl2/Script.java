package org.apache.commons.jexl2;

import java.util.List;
import java.util.Set;
import java.util.concurrent.Callable;

public interface Script {
    
    Object execute(JexlContext var1);

    Object execute(JexlContext var1, Object... var2);

    String getText();

    String[] getParameters();

    String[] getLocalVariables();

    Set<List<String>> getVariables();

    Callable<Object> callable(JexlContext var1);

    Callable<Object> callable(JexlContext var1, Object... var2);
}