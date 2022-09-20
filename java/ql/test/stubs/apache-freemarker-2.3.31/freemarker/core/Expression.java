// Generated automatically from freemarker.core.Expression for testing purposes

package freemarker.core;

import freemarker.core.Environment;
import freemarker.core.TemplateObject;
import freemarker.template.TemplateModel;

abstract public class Expression extends TemplateObject {
    protected abstract Expression deepCloneWithIdentifierReplaced_inner(String p0, Expression p1,
            Expression.ReplacemenetState p2);

    public Expression() {}

    public final TemplateModel getAsTemplateModel(Environment p0) {
        return null;
    }

    class ReplacemenetState {
    }
}
