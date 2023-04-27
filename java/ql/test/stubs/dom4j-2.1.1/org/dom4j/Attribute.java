// Generated automatically from org.dom4j.Attribute for testing purposes

package org.dom4j;

import org.dom4j.Namespace;
import org.dom4j.Node;
import org.dom4j.QName;

public interface Attribute extends Node
{
    Namespace getNamespace();
    Object getData();
    QName getQName();
    String getNamespacePrefix();
    String getNamespaceURI();
    String getQualifiedName();
    String getValue();
    void setData(Object p0);
    void setNamespace(Namespace p0);
    void setValue(String p0);
}
