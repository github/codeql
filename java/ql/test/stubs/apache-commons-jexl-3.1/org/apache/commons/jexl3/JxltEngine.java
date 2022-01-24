package org.apache.commons.jexl3;

import java.io.Writer;

public class JxltEngine {

    public Expression createExpression(String expression) {
        return null;
    }

    public Template createTemplate(String source) {
        return null;
    }

    public interface Expression {
        Object evaluate(JexlContext context);
        Expression prepare(JexlContext context);
    }

    public interface Template {
        void evaluate(JexlContext context, Writer writer);
        void evaluate(JexlContext context, Writer writer, Object... args);
        Template prepare(JexlContext context);
    }
}