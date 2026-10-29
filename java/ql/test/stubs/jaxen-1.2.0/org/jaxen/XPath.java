// Generated automatically from org.jaxen.XPath for testing purposes

package org.jaxen;

import java.util.List;
import org.jaxen.FunctionContext;
import org.jaxen.NamespaceContext;
import org.jaxen.Navigator;
import org.jaxen.VariableContext;

public interface XPath
{
    FunctionContext getFunctionContext();
    List selectNodes(Object p0);
    NamespaceContext getNamespaceContext();
    Navigator getNavigator();
    Number numberValueOf(Object p0);
    Object evaluate(Object p0);
    Object selectSingleNode(Object p0);
    String stringValueOf(Object p0);
    String valueOf(Object p0);
    VariableContext getVariableContext();
    boolean booleanValueOf(Object p0);
    void addNamespace(String p0, String p1);
    void setFunctionContext(FunctionContext p0);
    void setNamespaceContext(NamespaceContext p0);
    void setVariableContext(VariableContext p0);
}
