// Generated automatically from freemarker.core.DirectiveCallPlace for testing purposes

package freemarker.core;

import freemarker.template.Template;
import freemarker.template.utility.ObjectFactory;

public interface DirectiveCallPlace
{
    Object getOrCreateCustomData(Object p0, ObjectFactory p1);
    Template getTemplate();
    boolean isNestedOutputCacheable();
    int getBeginColumn();
    int getBeginLine();
    int getEndColumn();
    int getEndLine();
}
