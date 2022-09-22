// Generated automatically from org.thymeleaf.model.IModelFactory for testing purposes

package org.thymeleaf.model;

import java.util.Map;
import org.thymeleaf.engine.AttributeName;
import org.thymeleaf.engine.TemplateData;
import org.thymeleaf.model.AttributeValueQuotes;
import org.thymeleaf.model.ICDATASection;
import org.thymeleaf.model.ICloseElementTag;
import org.thymeleaf.model.IComment;
import org.thymeleaf.model.IDocType;
import org.thymeleaf.model.IModel;
import org.thymeleaf.model.IOpenElementTag;
import org.thymeleaf.model.IProcessableElementTag;
import org.thymeleaf.model.IProcessingInstruction;
import org.thymeleaf.model.IStandaloneElementTag;
import org.thymeleaf.model.ITemplateEvent;
import org.thymeleaf.model.IText;
import org.thymeleaf.model.IXMLDeclaration;

public interface IModelFactory
{
    <T extends IProcessableElementTag> T removeAttribute(T p0, AttributeName p1);
    <T extends IProcessableElementTag> T removeAttribute(T p0, String p1);
    <T extends IProcessableElementTag> T removeAttribute(T p0, String p1, String p2);
    <T extends IProcessableElementTag> T replaceAttribute(T p0, AttributeName p1, String p2, String p3);
    <T extends IProcessableElementTag> T replaceAttribute(T p0, AttributeName p1, String p2, String p3, AttributeValueQuotes p4);
    <T extends IProcessableElementTag> T setAttribute(T p0, String p1, String p2);
    <T extends IProcessableElementTag> T setAttribute(T p0, String p1, String p2, AttributeValueQuotes p3);
    ICDATASection createCDATASection(CharSequence p0);
    ICloseElementTag createCloseElementTag(String p0);
    ICloseElementTag createCloseElementTag(String p0, boolean p1, boolean p2);
    IComment createComment(CharSequence p0);
    IDocType createDocType(String p0, String p1);
    IDocType createDocType(String p0, String p1, String p2, String p3, String p4);
    IDocType createHTML5DocType();
    IModel createModel();
    IModel createModel(ITemplateEvent p0);
    IModel parse(TemplateData p0, String p1);
    IOpenElementTag createOpenElementTag(String p0);
    IOpenElementTag createOpenElementTag(String p0, Map<String, String> p1, AttributeValueQuotes p2, boolean p3);
    IOpenElementTag createOpenElementTag(String p0, String p1, String p2);
    IOpenElementTag createOpenElementTag(String p0, String p1, String p2, boolean p3);
    IOpenElementTag createOpenElementTag(String p0, boolean p1);
    IProcessingInstruction createProcessingInstruction(String p0, String p1);
    IStandaloneElementTag createStandaloneElementTag(String p0);
    IStandaloneElementTag createStandaloneElementTag(String p0, Map<String, String> p1, AttributeValueQuotes p2, boolean p3, boolean p4);
    IStandaloneElementTag createStandaloneElementTag(String p0, String p1, String p2);
    IStandaloneElementTag createStandaloneElementTag(String p0, String p1, String p2, boolean p3, boolean p4);
    IStandaloneElementTag createStandaloneElementTag(String p0, boolean p1, boolean p2);
    IText createText(CharSequence p0);
    IXMLDeclaration createXMLDeclaration(String p0, String p1, String p2);
}
