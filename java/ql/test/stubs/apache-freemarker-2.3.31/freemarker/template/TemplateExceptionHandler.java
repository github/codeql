// Generated automatically from freemarker.template.TemplateExceptionHandler for testing purposes

package freemarker.template;

import freemarker.core.Environment;
import freemarker.template.TemplateException;
import java.io.Writer;

public interface TemplateExceptionHandler
{
    static TemplateExceptionHandler DEBUG_HANDLER = null;
    static TemplateExceptionHandler HTML_DEBUG_HANDLER = null;
    static TemplateExceptionHandler IGNORE_HANDLER = null;
    static TemplateExceptionHandler RETHROW_HANDLER = null;
    void handleTemplateException(TemplateException p0, Environment p1, Writer p2);
}
