package org.thymeleaf;

import java.io.Writer;
import java.lang.String;
import java.util.Set;
import org.thymeleaf.context.IContext;
import org.thymeleaf.TemplateSpec;
import org.thymeleaf.ITemplateEngine;
import org.thymeleaf.IThrottledTemplateProcessor;

public class TemplateEngine implements ITemplateEngine {

    public String process(String template, Set<String> templateSelectors, IContext context) {
        return "";
    }

    public void process(String template, Set<String> templateSelectors, IContext context, Writer writer) {
    }

    public String process(String template, IContext context) {
        return "";
    }

    public void process(String template, IContext context, Writer writer) {
    }

    public String process(TemplateSpec templateSpec, IContext context) {
        return "";
    }

    public void process(TemplateSpec templateSpec, IContext context, Writer writer) {
    }

    public IThrottledTemplateProcessor processThrottled(String template, Set<String> templateSelectors,
            IContext context) {
        return new IThrottledTemplateProcessor() {
        };
    }

    public IThrottledTemplateProcessor processThrottled(String template, IContext context) {
        return new IThrottledTemplateProcessor() {
        };

    }

    public IThrottledTemplateProcessor processThrottled(TemplateSpec templateSpec, IContext context) {
        return new IThrottledTemplateProcessor() {
        };

    }
}
