// Generated automatically from org.thymeleaf.postprocessor.IPostProcessor for testing purposes

package org.thymeleaf.postprocessor;

import org.thymeleaf.engine.ITemplateHandler;
import org.thymeleaf.templatemode.TemplateMode;

public interface IPostProcessor
{
    Class<? extends ITemplateHandler> getHandlerClass();
    TemplateMode getTemplateMode();
    int getPrecedence();
}
