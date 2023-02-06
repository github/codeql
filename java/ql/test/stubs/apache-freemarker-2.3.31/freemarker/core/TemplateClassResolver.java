// Generated automatically from freemarker.core.TemplateClassResolver for testing purposes

package freemarker.core;

import freemarker.core.Environment;
import freemarker.template.Template;

public interface TemplateClassResolver
{
    Class resolve(String p0, Environment p1, Template p2);
    static TemplateClassResolver ALLOWS_NOTHING_RESOLVER = null;
    static TemplateClassResolver SAFER_RESOLVER = null;
    static TemplateClassResolver UNRESTRICTED_RESOLVER = null;
}
