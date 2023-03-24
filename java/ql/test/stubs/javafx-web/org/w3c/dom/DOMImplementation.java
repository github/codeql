// Generated automatically from org.w3c.dom.DOMImplementation for testing purposes

package org.w3c.dom;

import org.w3c.dom.Document;
import org.w3c.dom.DocumentType;

public interface DOMImplementation
{
    Document createDocument(String p0, String p1, DocumentType p2);
    DocumentType createDocumentType(String p0, String p1, String p2);
    Object getFeature(String p0, String p1);
    boolean hasFeature(String p0, String p1);
}
