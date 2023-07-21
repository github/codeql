// Generated automatically from org.jaxen.Navigator for testing purposes

package org.jaxen;

import java.io.Serializable;
import java.util.Iterator;
import org.jaxen.XPath;

public interface Navigator extends Serializable
{
    Iterator getAncestorAxisIterator(Object p0);
    Iterator getAncestorOrSelfAxisIterator(Object p0);
    Iterator getAttributeAxisIterator(Object p0);
    Iterator getChildAxisIterator(Object p0);
    Iterator getDescendantAxisIterator(Object p0);
    Iterator getDescendantOrSelfAxisIterator(Object p0);
    Iterator getFollowingAxisIterator(Object p0);
    Iterator getFollowingSiblingAxisIterator(Object p0);
    Iterator getNamespaceAxisIterator(Object p0);
    Iterator getParentAxisIterator(Object p0);
    Iterator getPrecedingAxisIterator(Object p0);
    Iterator getPrecedingSiblingAxisIterator(Object p0);
    Iterator getSelfAxisIterator(Object p0);
    Object getDocument(String p0);
    Object getDocumentNode(Object p0);
    Object getElementById(Object p0, String p1);
    Object getParentNode(Object p0);
    String getAttributeName(Object p0);
    String getAttributeNamespaceUri(Object p0);
    String getAttributeQName(Object p0);
    String getAttributeStringValue(Object p0);
    String getCommentStringValue(Object p0);
    String getElementName(Object p0);
    String getElementNamespaceUri(Object p0);
    String getElementQName(Object p0);
    String getElementStringValue(Object p0);
    String getNamespacePrefix(Object p0);
    String getNamespaceStringValue(Object p0);
    String getProcessingInstructionData(Object p0);
    String getProcessingInstructionTarget(Object p0);
    String getTextStringValue(Object p0);
    String translateNamespacePrefixToUri(String p0, Object p1);
    XPath parseXPath(String p0);
    boolean isAttribute(Object p0);
    boolean isComment(Object p0);
    boolean isDocument(Object p0);
    boolean isElement(Object p0);
    boolean isNamespace(Object p0);
    boolean isProcessingInstruction(Object p0);
    boolean isText(Object p0);
    short getNodeType(Object p0);
}
