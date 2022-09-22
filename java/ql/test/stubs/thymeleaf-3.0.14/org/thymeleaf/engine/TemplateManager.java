// Generated automatically from org.thymeleaf.engine.TemplateManager for testing purposes

package org.thymeleaf.engine;

import java.io.Writer;
import java.util.Set;
import org.thymeleaf.IEngineConfiguration;
import org.thymeleaf.TemplateSpec;
import org.thymeleaf.context.IContext;
import org.thymeleaf.context.ITemplateContext;
import org.thymeleaf.engine.TemplateData;
import org.thymeleaf.engine.TemplateModel;
import org.thymeleaf.engine.ThrottledTemplateProcessor;
import org.thymeleaf.templatemode.TemplateMode;

public class TemplateManager
{
    protected TemplateManager() {}
    public TemplateManager(IEngineConfiguration p0){}
    public TemplateModel parseStandalone(ITemplateContext p0, String p1, Set<String> p2, TemplateMode p3, boolean p4, boolean p5){ return null; }
    public TemplateModel parseString(TemplateData p0, String p1, int p2, int p3, TemplateMode p4, boolean p5){ return null; }
    public ThrottledTemplateProcessor parseAndProcessThrottled(TemplateSpec p0, IContext p1){ return null; }
    public void clearCaches(){}
    public void clearCachesFor(String p0){}
    public void parseAndProcess(TemplateSpec p0, IContext p1, Writer p2){}
    public void process(TemplateModel p0, ITemplateContext p1, Writer p2){}
}
