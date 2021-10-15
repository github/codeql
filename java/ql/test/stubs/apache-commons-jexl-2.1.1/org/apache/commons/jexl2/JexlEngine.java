package org.apache.commons.jexl2;

import java.util.Map;
import org.apache.commons.jexl2.introspection.*;
import org.apache.commons.logging.Log;

public class JexlEngine {

    public JexlEngine() {
    }

    public JexlEngine(Uberspect uberspect, JexlArithmetic arithmetic, Map<String, Object> functions, Log log) {
    }

    public Expression createExpression(String expression) {
        return null;
    }

    public Expression createExpression(String expression, JexlInfo info) {
        return null;
    }

    public Script createScript(String scriptText) {
        return null;
    }

    public Script createScript(String scriptText, JexlInfo info) {
        return null;
    }

    public Script createScript(String scriptText, String... names) {
        return null;
    }

    public Script createScript(String scriptText, JexlInfo info, String[] names) {
        return null;
    }

    public Object getProperty(Object bean, String expr) {
        return null;
    }

    public Object getProperty(JexlContext context, Object bean, String expr) {
        return null;
    }

    public void setProperty(Object bean, String expr, Object value) {
    }

    public void setProperty(JexlContext context, Object bean, String expr, Object value) {
    }

}