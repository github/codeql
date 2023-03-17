// Generated automatically from org.dom4j.XPath for testing purposes

package org.dom4j;

import java.util.List;
import java.util.Map;
import org.dom4j.Node;
import org.dom4j.NodeFilter;
import org.jaxen.FunctionContext;
import org.jaxen.NamespaceContext;
import org.jaxen.VariableContext;

public interface XPath extends NodeFilter
{
    FunctionContext getFunctionContext();
    List selectNodes(Object p0);
    List selectNodes(Object p0, XPath p1);
    List selectNodes(Object p0, XPath p1, boolean p2);
    NamespaceContext getNamespaceContext();
    Node selectSingleNode(Object p0);
    Number numberValueOf(Object p0);
    Object evaluate(Object p0);
    Object selectObject(Object p0);
    String getText();
    String valueOf(Object p0);
    VariableContext getVariableContext();
    boolean booleanValueOf(Object p0);
    boolean matches(Node p0);
    void setFunctionContext(FunctionContext p0);
    void setNamespaceContext(NamespaceContext p0);
    void setNamespaceURIs(Map p0);
    void setVariableContext(VariableContext p0);
    void sort(List p0);
    void sort(List p0, boolean p1);
}
