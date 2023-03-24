// Generated automatically from org.thymeleaf.processor.templateboundaries.ITemplateBoundariesProcessor for testing purposes

package org.thymeleaf.processor.templateboundaries;

import org.thymeleaf.context.ITemplateContext;
import org.thymeleaf.model.ITemplateEnd;
import org.thymeleaf.model.ITemplateStart;
import org.thymeleaf.processor.IProcessor;
import org.thymeleaf.processor.templateboundaries.ITemplateBoundariesStructureHandler;

public interface ITemplateBoundariesProcessor extends IProcessor
{
    void processTemplateEnd(ITemplateContext p0, ITemplateEnd p1, ITemplateBoundariesStructureHandler p2);
    void processTemplateStart(ITemplateContext p0, ITemplateStart p1, ITemplateBoundariesStructureHandler p2);
}
