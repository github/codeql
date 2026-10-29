// Generated automatically from org.w3c.dom.Attr for testing purposes

package org.w3c.dom;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.TypeInfo;

public interface Attr extends Node
{
    Element getOwnerElement();
    String getName();
    String getValue();
    TypeInfo getSchemaTypeInfo();
    boolean getSpecified();
    boolean isId();
    void setValue(String p0);
}
