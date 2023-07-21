// Generated automatically from org.dom4j.Node for testing purposes

package org.dom4j;

import java.io.Writer;
import java.util.List;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.Visitor;
import org.dom4j.XPath;

public interface Node extends Cloneable
{
    Document getDocument();
    Element getParent();
    List selectNodes(String p0);
    List selectNodes(String p0, String p1);
    List selectNodes(String p0, String p1, boolean p2);
    Node asXPathResult(Element p0);
    Node detach();
    Node selectSingleNode(String p0);
    Number numberValueOf(String p0);
    Object clone();
    Object selectObject(String p0);
    String asXML();
    String getName();
    String getNodeTypeName();
    String getPath();
    String getPath(Element p0);
    String getStringValue();
    String getText();
    String getUniquePath();
    String getUniquePath(Element p0);
    String valueOf(String p0);
    XPath createXPath(String p0);
    boolean hasContent();
    boolean isReadOnly();
    boolean matches(String p0);
    boolean supportsParent();
    short getNodeType();
    static short ANY_NODE = 0;
    static short ATTRIBUTE_NODE = 0;
    static short CDATA_SECTION_NODE = 0;
    static short COMMENT_NODE = 0;
    static short DOCUMENT_NODE = 0;
    static short DOCUMENT_TYPE_NODE = 0;
    static short ELEMENT_NODE = 0;
    static short ENTITY_REFERENCE_NODE = 0;
    static short MAX_NODE_TYPE = 0;
    static short NAMESPACE_NODE = 0;
    static short PROCESSING_INSTRUCTION_NODE = 0;
    static short TEXT_NODE = 0;
    static short UNKNOWN_NODE = 0;
    void accept(Visitor p0);
    void setDocument(Document p0);
    void setName(String p0);
    void setParent(Element p0);
    void setText(String p0);
    void write(Writer p0);
}
