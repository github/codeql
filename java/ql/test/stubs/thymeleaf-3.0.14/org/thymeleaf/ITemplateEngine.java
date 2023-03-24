// Generated automatically from org.thymeleaf.ITemplateEngine for testing purposes

package org.thymeleaf;

import java.io.Writer;
import java.util.Set;
import org.thymeleaf.IEngineConfiguration;
import org.thymeleaf.IThrottledTemplateProcessor;
import org.thymeleaf.TemplateSpec;
import org.thymeleaf.context.IContext;

public interface ITemplateEngine
{
    IEngineConfiguration getConfiguration();
    IThrottledTemplateProcessor processThrottled(String p0, IContext p1);
    IThrottledTemplateProcessor processThrottled(String p0, Set<String> p1, IContext p2);
    IThrottledTemplateProcessor processThrottled(TemplateSpec p0, IContext p1);
    String process(String p0, IContext p1);
    String process(String p0, Set<String> p1, IContext p2);
    String process(TemplateSpec p0, IContext p1);
    void process(String p0, IContext p1, Writer p2);
    void process(String p0, Set<String> p1, IContext p2, Writer p3);
    void process(TemplateSpec p0, IContext p1, Writer p2);
}
