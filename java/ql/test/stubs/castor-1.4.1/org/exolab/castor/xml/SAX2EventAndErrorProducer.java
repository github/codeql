package org.exolab.castor.xml;

import org.xml.sax.ErrorHandler;

public interface SAX2EventAndErrorProducer extends SAX2EventProducer {
    void setErrorHandler(ErrorHandler var1);
}

