package org.apache.commons.jexl2;

public interface JexlContext {
    Object get(String var1);
    void set(String var1, Object var2);
    boolean has(String var1);
}
