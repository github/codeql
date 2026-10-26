// Generated automatically from org.dom4j.Document for testing purposes

package org.dom4j;

import java.util.Map;
import org.dom4j.Branch;
import org.dom4j.DocumentType;
import org.dom4j.Element;
import org.xml.sax.EntityResolver;

public interface Document extends Branch
{
    Document addComment(String p0);
    Document addDocType(String p0, String p1, String p2);
    Document addProcessingInstruction(String p0, Map p1);
    Document addProcessingInstruction(String p0, String p1);
    DocumentType getDocType();
    Element getRootElement();
    EntityResolver getEntityResolver();
    String getXMLEncoding();
    void setDocType(DocumentType p0);
    void setEntityResolver(EntityResolver p0);
    void setRootElement(Element p0);
}
