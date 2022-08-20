// Generated automatically from org.w3c.dom.Element for testing purposes

package org.w3c.dom;

import org.w3c.dom.Attr;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.TypeInfo;

public interface Element extends Node
{
    Attr getAttributeNode(String p0);
    Attr getAttributeNodeNS(String p0, String p1);
    Attr removeAttributeNode(Attr p0);
    Attr setAttributeNode(Attr p0);
    Attr setAttributeNodeNS(Attr p0);
    NodeList getElementsByTagName(String p0);
    NodeList getElementsByTagNameNS(String p0, String p1);
    String getAttribute(String p0);
    String getAttributeNS(String p0, String p1);
    String getTagName();
    TypeInfo getSchemaTypeInfo();
    boolean hasAttribute(String p0);
    boolean hasAttributeNS(String p0, String p1);
    void removeAttribute(String p0);
    void removeAttributeNS(String p0, String p1);
    void setAttribute(String p0, String p1);
    void setAttributeNS(String p0, String p1, String p2);
    void setIdAttribute(String p0, boolean p1);
    void setIdAttributeNS(String p0, String p1, boolean p2);
    void setIdAttributeNode(Attr p0, boolean p1);
}
