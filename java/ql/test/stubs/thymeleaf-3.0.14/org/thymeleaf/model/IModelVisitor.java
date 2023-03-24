// Generated automatically from org.thymeleaf.model.IModelVisitor for testing purposes

package org.thymeleaf.model;

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

public interface IModelVisitor
{
    void visit(ICDATASection p0);
    void visit(ICloseElementTag p0);
    void visit(IComment p0);
    void visit(IDocType p0);
    void visit(IOpenElementTag p0);
    void visit(IProcessingInstruction p0);
    void visit(IStandaloneElementTag p0);
    void visit(ITemplateEnd p0);
    void visit(ITemplateStart p0);
    void visit(IText p0);
    void visit(IXMLDeclaration p0);
}
