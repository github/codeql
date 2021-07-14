package org.apache.commons.jexl3;

import org.apache.commons.jexl3.introspection.*;

public abstract class JexlEngine {

    public JexlExpression createExpression(JexlInfo info, String expression) {
        return null;
    }

    public JexlExpression createExpression(String expression) {
        return null;
    }

    public JexlScript createScript(JexlInfo info, String source, String[] names) {
        return null;
    }

    public JexlScript createScript(String scriptText) {
        return null;
    }

    public JexlScript createScript(String scriptText, String... names) {
        return null;
    }

    public JxltEngine createJxltEngine() {
        return null;
    }

    public void setProperty(Object bean, String expr, Object value) {}

    public Object getProperty(Object bean, String expr) {
        return null;
    }

    public JexlUberspect getUberspect() {
        return null;
    }
}