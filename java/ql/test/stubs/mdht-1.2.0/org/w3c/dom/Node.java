// Generated automatically from org.w3c.dom.Node for testing purposes

package org.w3c.dom;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.NodeList;
import org.w3c.dom.UserDataHandler;

public interface Node
{
    Document getOwnerDocument();
    NamedNodeMap getAttributes();
    Node appendChild(Node p0);
    Node cloneNode(boolean p0);
    Node getFirstChild();
    Node getLastChild();
    Node getNextSibling();
    Node getParentNode();
    Node getPreviousSibling();
    Node insertBefore(Node p0, Node p1);
    Node removeChild(Node p0);
    Node replaceChild(Node p0, Node p1);
    NodeList getChildNodes();
    Object getFeature(String p0, String p1);
    Object getUserData(String p0);
    Object setUserData(String p0, Object p1, UserDataHandler p2);
    String getBaseURI();
    String getLocalName();
    String getNamespaceURI();
    String getNodeName();
    String getNodeValue();
    String getPrefix();
    String getTextContent();
    String lookupNamespaceURI(String p0);
    String lookupPrefix(String p0);
    boolean hasAttributes();
    boolean hasChildNodes();
    boolean isDefaultNamespace(String p0);
    boolean isEqualNode(Node p0);
    boolean isSameNode(Node p0);
    boolean isSupported(String p0, String p1);
    short compareDocumentPosition(Node p0);
    short getNodeType();
    static short ATTRIBUTE_NODE = 0;
    static short CDATA_SECTION_NODE = 0;
    static short COMMENT_NODE = 0;
    static short DOCUMENT_FRAGMENT_NODE = 0;
    static short DOCUMENT_NODE = 0;
    static short DOCUMENT_POSITION_CONTAINED_BY = 0;
    static short DOCUMENT_POSITION_CONTAINS = 0;
    static short DOCUMENT_POSITION_DISCONNECTED = 0;
    static short DOCUMENT_POSITION_FOLLOWING = 0;
    static short DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 0;
    static short DOCUMENT_POSITION_PRECEDING = 0;
    static short DOCUMENT_TYPE_NODE = 0;
    static short ELEMENT_NODE = 0;
    static short ENTITY_NODE = 0;
    static short ENTITY_REFERENCE_NODE = 0;
    static short NOTATION_NODE = 0;
    static short PROCESSING_INSTRUCTION_NODE = 0;
    static short TEXT_NODE = 0;
    void normalize();
    void setNodeValue(String p0);
    void setPrefix(String p0);
    void setTextContent(String p0);
}
