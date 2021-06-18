package org.exolab.castor.xml;

import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;

public interface SAX2EventProducer {
    void setContentHandler(ContentHandler var1);

    void start() throws SAXException;
}

