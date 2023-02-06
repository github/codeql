// Generated automatically from org.thymeleaf.model.IElementTag for testing purposes

package org.thymeleaf.model;

import org.thymeleaf.engine.ElementDefinition;
import org.thymeleaf.model.ITemplateEvent;
import org.thymeleaf.templatemode.TemplateMode;

public interface IElementTag extends ITemplateEvent
{
    ElementDefinition getElementDefinition();
    String getElementCompleteName();
    TemplateMode getTemplateMode();
    boolean isSynthetic();
}
