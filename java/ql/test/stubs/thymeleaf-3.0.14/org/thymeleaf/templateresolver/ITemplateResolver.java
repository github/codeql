// Generated automatically from org.thymeleaf.templateresolver.ITemplateResolver for testing purposes

package org.thymeleaf.templateresolver;

import java.util.Map;
import org.thymeleaf.IEngineConfiguration;
import org.thymeleaf.templateresolver.TemplateResolution;

public interface ITemplateResolver
{
    Integer getOrder();
    String getName();
    TemplateResolution resolveTemplate(IEngineConfiguration p0, String p1, String p2, Map<String, Object> p3);
}
