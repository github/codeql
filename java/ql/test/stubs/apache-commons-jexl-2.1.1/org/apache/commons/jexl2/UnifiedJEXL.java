package org.apache.commons.jexl2;

import java.io.Writer;
import java.io.Reader;

public final class UnifiedJEXL {

    public UnifiedJEXL(JexlEngine jexl) {}

    public UnifiedJEXL.Expression parse(String expression) {
        return null;
    }

    public UnifiedJEXL.Template createTemplate(String prefix, Reader source, String... parms) {
        return null;
    }

    public UnifiedJEXL.Template createTemplate(String source, String... parms) {
        return null;
    }

    public UnifiedJEXL.Template createTemplate(String source) {
        return null;
    }

    public final class Template {

        public UnifiedJEXL.Template prepare(JexlContext context) {
            return null;
        }

        public void evaluate(JexlContext context, Writer writer) {}

        public void evaluate(JexlContext context, Writer writer, Object... args) {}
    }

    public abstract class Expression {

        public UnifiedJEXL.Expression prepare(JexlContext context) {
            return null;
        }

        public Object evaluate(JexlContext context) {
            return null;
        }
    }
}