// Generated automatically from org.w3c.dom.DocumentType for testing purposes

package org.w3c.dom;

import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;

public interface DocumentType extends Node
{
    NamedNodeMap getEntities();
    NamedNodeMap getNotations();
    String getInternalSubset();
    String getName();
    String getPublicId();
    String getSystemId();
}
