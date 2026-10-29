package org.exolab.castor.xml;

import org.xml.sax.DocumentHandler;
import org.xml.sax.SAXException;

/** @deprecated */
public interface EventProducer {
    void setDocumentHandler(DocumentHandler var1);

    void start() throws SAXException;
}

