package org.thymeleaf;

import java.io.Writer;
import java.lang.String;
import java.util.Set;
import org.thymeleaf.context.IContext;   
import org.thymeleaf.*;   

public interface ITemplateEngine {

    public String process(String template, Set<String> templateSelectors, IContext context);

    public void process(String template, Set<String> templateSelectors, IContext context, Writer writer);

    public String process(String template, IContext context);

    public void process(String template, IContext context, Writer writer);

    public String process(TemplateSpec templateSpec, IContext context);

    public void process(TemplateSpec templateSpec, IContext context, Writer writer);

    public IThrottledTemplateProcessor processThrottled(String template, Set<String> templateSelectors, IContext context);

    public IThrottledTemplateProcessor processThrottled(String template, IContext context);

    public IThrottledTemplateProcessor processThrottled(TemplateSpec templateSpec, IContext context);
}
