// Generated automatically from freemarker.template.AttemptExceptionReporter for testing purposes

package freemarker.template;

import freemarker.core.Environment;
import freemarker.template.TemplateException;

public interface AttemptExceptionReporter
{
    static AttemptExceptionReporter LOG_ERROR_REPORTER = null;
    static AttemptExceptionReporter LOG_WARN_REPORTER = null;
    void report(TemplateException p0, Environment p1);
}
