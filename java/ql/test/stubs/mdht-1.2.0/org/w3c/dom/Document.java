// Generated automatically from org.w3c.dom.Document for testing purposes

package org.w3c.dom;

import org.w3c.dom.Attr;
import org.w3c.dom.CDATASection;
import org.w3c.dom.Comment;
import org.w3c.dom.DOMConfiguration;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.DocumentFragment;
import org.w3c.dom.DocumentType;
import org.w3c.dom.Element;
import org.w3c.dom.EntityReference;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.ProcessingInstruction;
import org.w3c.dom.Text;

public interface Document extends Node
{
    Attr createAttribute(String p0);
    Attr createAttributeNS(String p0, String p1);
    CDATASection createCDATASection(String p0);
    Comment createComment(String p0);
    DOMConfiguration getDomConfig();
    DOMImplementation getImplementation();
    DocumentFragment createDocumentFragment();
    DocumentType getDoctype();
    Element createElement(String p0);
    Element createElementNS(String p0, String p1);
    Element getDocumentElement();
    Element getElementById(String p0);
    EntityReference createEntityReference(String p0);
    Node adoptNode(Node p0);
    Node importNode(Node p0, boolean p1);
    Node renameNode(Node p0, String p1, String p2);
    NodeList getElementsByTagName(String p0);
    NodeList getElementsByTagNameNS(String p0, String p1);
    ProcessingInstruction createProcessingInstruction(String p0, String p1);
    String getDocumentURI();
    String getInputEncoding();
    String getXmlEncoding();
    String getXmlVersion();
    Text createTextNode(String p0);
    boolean getStrictErrorChecking();
    boolean getXmlStandalone();
    void normalizeDocument();
    void setDocumentURI(String p0);
    void setStrictErrorChecking(boolean p0);
    void setXmlStandalone(boolean p0);
    void setXmlVersion(String p0);
}
