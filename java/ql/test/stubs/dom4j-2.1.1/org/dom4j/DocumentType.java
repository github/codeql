// Generated automatically from org.dom4j.DocumentType for testing purposes

package org.dom4j;

import java.util.List;
import org.dom4j.Node;

public interface DocumentType extends Node
{
    List getExternalDeclarations();
    List getInternalDeclarations();
    String getElementName();
    String getPublicID();
    String getSystemID();
    void setElementName(String p0);
    void setExternalDeclarations(List p0);
    void setInternalDeclarations(List p0);
    void setPublicID(String p0);
    void setSystemID(String p0);
}
