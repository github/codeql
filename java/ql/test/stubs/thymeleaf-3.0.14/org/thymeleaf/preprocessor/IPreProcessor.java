// Generated automatically from org.thymeleaf.preprocessor.IPreProcessor for testing purposes

package org.thymeleaf.preprocessor;

import org.thymeleaf.engine.ITemplateHandler;
import org.thymeleaf.templatemode.TemplateMode;

public interface IPreProcessor
{
    Class<? extends ITemplateHandler> getHandlerClass();
    TemplateMode getTemplateMode();
    int getPrecedence();
}
