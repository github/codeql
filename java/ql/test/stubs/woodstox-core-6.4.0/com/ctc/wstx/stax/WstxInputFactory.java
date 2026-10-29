// Generated automatically from com.ctc.wstx.stax.WstxInputFactory for testing purposes

package com.ctc.wstx.stax;

import java.io.InputStream;
import java.io.Reader;
import javax.xml.stream.EventFilter;
import javax.xml.stream.StreamFilter;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLReporter;
import javax.xml.stream.XMLResolver;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import javax.xml.stream.util.XMLEventAllocator;
import javax.xml.transform.Source;
import org.codehaus.stax2.XMLInputFactory2;

public class WstxInputFactory extends XMLInputFactory2 {
    public WstxInputFactory() {}

    public XMLStreamReader createXMLStreamReader(InputStream in) throws XMLStreamException { return null; }
    public XMLStreamReader createXMLStreamReader(InputStream in, String enc) throws XMLStreamException { return null; }
    public XMLStreamReader createXMLStreamReader(Reader r) throws XMLStreamException { return null; }
    public XMLStreamReader createXMLStreamReader(Source src) throws XMLStreamException { return null; }
    public XMLStreamReader createXMLStreamReader(String systemId, InputStream in) throws XMLStreamException { return null; }
    public XMLStreamReader createXMLStreamReader(String systemId, Reader r) throws XMLStreamException { return null; }

    public XMLEventReader createXMLEventReader(InputStream in) throws XMLStreamException { return null; }
    public XMLEventReader createXMLEventReader(InputStream in, String enc) throws XMLStreamException { return null; }
    public XMLEventReader createXMLEventReader(Reader r) throws XMLStreamException { return null; }
    public XMLEventReader createXMLEventReader(Source src) throws XMLStreamException { return null; }
    public XMLEventReader createXMLEventReader(String systemId, InputStream in) throws XMLStreamException { return null; }
    public XMLEventReader createXMLEventReader(String systemId, Reader r) throws XMLStreamException { return null; }
    public XMLEventReader createXMLEventReader(XMLStreamReader sr) throws XMLStreamException { return null; }

    public XMLStreamReader createFilteredReader(XMLStreamReader reader, StreamFilter filter) { return null; }
    public XMLEventReader createFilteredReader(XMLEventReader reader, EventFilter filter) { return null; }

    public void setProperty(String name, Object value) {}
    public Object getProperty(String name) { return null; }
    public boolean isPropertySupported(String name) { return false; }

    public XMLResolver getXMLResolver() { return null; }
    public void setXMLResolver(XMLResolver r) {}
    public XMLReporter getXMLReporter() { return null; }
    public void setXMLReporter(XMLReporter r) {}
    public XMLEventAllocator getEventAllocator() { return null; }
    public void setEventAllocator(XMLEventAllocator a) {}
}
