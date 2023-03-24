// Generated automatically from org.thymeleaf.TemplateEngine for testing purposes

package org.thymeleaf;

import java.io.Writer;
import java.util.Map;
import java.util.Set;
import org.thymeleaf.IEngineConfiguration;
import org.thymeleaf.ITemplateEngine;
import org.thymeleaf.IThrottledTemplateProcessor;
import org.thymeleaf.TemplateSpec;
import org.thymeleaf.cache.ICacheManager;
import org.thymeleaf.context.IContext;
import org.thymeleaf.context.IEngineContextFactory;
import org.thymeleaf.dialect.IDialect;
import org.thymeleaf.linkbuilder.ILinkBuilder;
import org.thymeleaf.messageresolver.IMessageResolver;
import org.thymeleaf.templateparser.markup.decoupled.IDecoupledTemplateLogicResolver;
import org.thymeleaf.templateresolver.ITemplateResolver;

public class TemplateEngine implements ITemplateEngine
{
    protected void initializeSpecific(){}
    public IEngineConfiguration getConfiguration(){ return null; }
    public TemplateEngine(){}
    public final ICacheManager getCacheManager(){ return null; }
    public final IDecoupledTemplateLogicResolver getDecoupledTemplateLogicResolver(){ return null; }
    public final IEngineContextFactory getEngineContextFactory(){ return null; }
    public final IThrottledTemplateProcessor processThrottled(String p0, IContext p1){ return null; }
    public final IThrottledTemplateProcessor processThrottled(String p0, Set<String> p1, IContext p2){ return null; }
    public final IThrottledTemplateProcessor processThrottled(TemplateSpec p0, IContext p1){ return null; }
    public final Map<String, Set<IDialect>> getDialectsByPrefix(){ return null; }
    public final Set<IDialect> getDialects(){ return null; }
    public final Set<ILinkBuilder> getLinkBuilders(){ return null; }
    public final Set<IMessageResolver> getMessageResolvers(){ return null; }
    public final Set<ITemplateResolver> getTemplateResolvers(){ return null; }
    public final String process(String p0, IContext p1){ return null; }
    public final String process(String p0, Set<String> p1, IContext p2){ return null; }
    public final String process(TemplateSpec p0, IContext p1){ return null; }
    public final boolean isInitialized(){ return false; }
    public final void process(String p0, IContext p1, Writer p2){}
    public final void process(String p0, Set<String> p1, IContext p2, Writer p3){}
    public final void process(TemplateSpec p0, IContext p1, Writer p2){}
    public static String TIMER_LOGGER_NAME = null;
    public static String threadIndex(){ return null; }
    public void addDialect(IDialect p0){}
    public void addDialect(String p0, IDialect p1){}
    public void addLinkBuilder(ILinkBuilder p0){}
    public void addMessageResolver(IMessageResolver p0){}
    public void addTemplateResolver(ITemplateResolver p0){}
    public void clearDialects(){}
    public void clearTemplateCache(){}
    public void clearTemplateCacheFor(String p0){}
    public void setAdditionalDialects(Set<IDialect> p0){}
    public void setCacheManager(ICacheManager p0){}
    public void setDecoupledTemplateLogicResolver(IDecoupledTemplateLogicResolver p0){}
    public void setDialect(IDialect p0){}
    public void setDialects(Set<IDialect> p0){}
    public void setDialectsByPrefix(Map<String, IDialect> p0){}
    public void setEngineContextFactory(IEngineContextFactory p0){}
    public void setLinkBuilder(ILinkBuilder p0){}
    public void setLinkBuilders(Set<ILinkBuilder> p0){}
    public void setMessageResolver(IMessageResolver p0){}
    public void setMessageResolvers(Set<IMessageResolver> p0){}
    public void setTemplateResolver(ITemplateResolver p0){}
    public void setTemplateResolvers(Set<ITemplateResolver> p0){}
}
