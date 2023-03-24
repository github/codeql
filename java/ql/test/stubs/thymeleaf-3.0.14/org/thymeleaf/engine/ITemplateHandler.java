// Generated automatically from org.thymeleaf.engine.ITemplateHandler for testing purposes

package org.thymeleaf.engine;

import org.thymeleaf.context.ITemplateContext;
import org.thymeleaf.model.ICDATASection;
import org.thymeleaf.model.ICloseElementTag;
import org.thymeleaf.model.IComment;
import org.thymeleaf.model.IDocType;
import org.thymeleaf.model.IOpenElementTag;
import org.thymeleaf.model.IProcessingInstruction;
import org.thymeleaf.model.IStandaloneElementTag;
import org.thymeleaf.model.ITemplateEnd;
import org.thymeleaf.model.ITemplateStart;
import org.thymeleaf.model.IText;
import org.thymeleaf.model.IXMLDeclaration;

public interface ITemplateHandler
{
    void handleCDATASection(ICDATASection p0);
    void handleCloseElement(ICloseElementTag p0);
    void handleComment(IComment p0);
    void handleDocType(IDocType p0);
    void handleOpenElement(IOpenElementTag p0);
    void handleProcessingInstruction(IProcessingInstruction p0);
    void handleStandaloneElement(IStandaloneElementTag p0);
    void handleTemplateEnd(ITemplateEnd p0);
    void handleTemplateStart(ITemplateStart p0);
    void handleText(IText p0);
    void handleXMLDeclaration(IXMLDeclaration p0);
    void setContext(ITemplateContext p0);
    void setNext(ITemplateHandler p0);
}
