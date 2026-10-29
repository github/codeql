// Generated automatically from org.apache.commons.jelly.XMLOutput for testing purposes

package org.apache.commons.jelly;

import java.io.OutputStream;
import java.io.Writer;
import org.dom4j.io.XMLWriter;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.XMLReader;
import org.xml.sax.ext.LexicalHandler;

public class XMLOutput implements ContentHandler, LexicalHandler
{
    protected static String[] LEXICAL_HANDLER_NAMES = null;
    protected static XMLOutput createXMLOutput(XMLWriter p0){ return null; }
    public ContentHandler getContentHandler(){ return null; }
    public LexicalHandler getLexicalHandler(){ return null; }
    public String toString(){ return null; }
    public XMLOutput(){}
    public XMLOutput(ContentHandler p0){}
    public XMLOutput(ContentHandler p0, LexicalHandler p1){}
    public static XMLOutput createDummyXMLOutput(){ return null; }
    public static XMLOutput createXMLOutput(OutputStream p0){ return null; }
    public static XMLOutput createXMLOutput(OutputStream p0, boolean p1){ return null; }
    public static XMLOutput createXMLOutput(Writer p0){ return null; }
    public static XMLOutput createXMLOutput(Writer p0, boolean p1){ return null; }
    public static XMLOutput createXMLOutput(XMLReader p0){ return null; }
    public void characters(char[] p0, int p1, int p2){}
    public void close(){}
    public void comment(char[] p0, int p1, int p2){}
    public void endCDATA(){}
    public void endDTD(){}
    public void endDocument(){}
    public void endElement(String p0){}
    public void endElement(String p0, String p1, String p2){}
    public void endEntity(String p0){}
    public void endPrefixMapping(String p0){}
    public void flush(){}
    public void ignorableWhitespace(char[] p0, int p1, int p2){}
    public void objectData(Object p0){}
    public void processingInstruction(String p0, String p1){}
    public void setContentHandler(ContentHandler p0){}
    public void setDocumentLocator(Locator p0){}
    public void setLexicalHandler(LexicalHandler p0){}
    public void skippedEntity(String p0){}
    public void startCDATA(){}
    public void startDTD(String p0, String p1, String p2){}
    public void startDocument(){}
    public void startElement(String p0){}
    public void startElement(String p0, Attributes p1){}
    public void startElement(String p0, String p1, String p2, Attributes p3){}
    public void startEntity(String p0){}
    public void startPrefixMapping(String p0, String p1){}
    public void write(String p0){}
    public void writeCDATA(String p0){}
    public void writeComment(String p0){}
}
