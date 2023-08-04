// Generated automatically from org.apache.commons.jelly.parser.XMLParser for testing purposes

package org.apache.commons.jelly.parser;

import java.io.File;
import java.io.InputStream;
import java.io.Reader;
import java.net.URL;
import java.util.Map;
import java.util.Properties;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.apache.commons.jelly.JellyContext;
import org.apache.commons.jelly.Script;
import org.apache.commons.jelly.expression.Expression;
import org.apache.commons.jelly.expression.ExpressionFactory;
import org.apache.commons.jelly.impl.ScriptBlock;
import org.apache.commons.jelly.impl.TagScript;
import org.apache.commons.logging.Log;
import org.xml.sax.Attributes;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

public class XMLParser extends DefaultHandler
{
    protected ClassLoader classLoader = null;
    protected ErrorHandler errorHandler = null;
    protected Expression createConstantExpression(String p0, String p1, String p2){ return null; }
    protected ExpressionFactory createExpressionFactory(){ return null; }
    protected Locator locator = null;
    protected Map namespaces = null;
    protected Properties getJellyProperties(){ return null; }
    protected SAXException createSAXException(Exception p0){ return null; }
    protected SAXException createSAXException(String p0){ return null; }
    protected SAXException createSAXException(String p0, Exception p1){ return null; }
    protected SAXParser parser = null;
    protected String getCurrentURI(){ return null; }
    protected TagScript createStaticTag(String p0, String p1, String p2, Attributes p3){ return null; }
    protected TagScript createTag(String p0, String p1, Attributes p2){ return null; }
    protected XMLReader reader = null;
    protected boolean useContextClassLoader = false;
    protected boolean validating = false;
    protected static SAXParserFactory factory = null;
    protected void addExpressionScript(ScriptBlock p0, Expression p1){}
    protected void addTextScript(String p0){}
    protected void configure(){}
    protected void configureTagScript(TagScript p0){}
    public ClassLoader getClassLoader(){ return null; }
    public ErrorHandler getErrorHandler(){ return null; }
    public ExpressionFactory getExpressionFactory(){ return null; }
    public JellyContext getContext(){ return null; }
    public Log getLogger(){ return null; }
    public SAXParser getParser(){ return null; }
    public Script parse(File p0){ return null; }
    public Script parse(InputSource p0){ return null; }
    public Script parse(InputStream p0){ return null; }
    public Script parse(Reader p0){ return null; }
    public Script parse(String p0){ return null; }
    public Script parse(URL p0){ return null; }
    public ScriptBlock getScript(){ return null; }
    public String findNamespaceURI(String p0){ return null; }
    public XMLParser(){}
    public XMLParser(SAXParser p0){}
    public XMLParser(XMLReader p0){}
    public XMLParser(boolean p0){}
    public XMLReader getReader(){ return null; }
    public XMLReader getXMLReader(){ return null; }
    public boolean getUseContextClassLoader(){ return false; }
    public boolean getValidating(){ return false; }
    public void characters(char[] p0, int p1, int p2){}
    public void endDocument(){}
    public void endElement(String p0, String p1, String p2){}
    public void endPrefixMapping(String p0){}
    public void error(SAXParseException p0){}
    public void fatalError(SAXParseException p0){}
    public void ignorableWhitespace(char[] p0, int p1, int p2){}
    public void notationDecl(String p0, String p1, String p2){}
    public void processingInstruction(String p0, String p1){}
    public void setClassLoader(ClassLoader p0){}
    public void setContext(JellyContext p0){}
    public void setDefaultNamespaceURI(String p0){}
    public void setDocumentLocator(Locator p0){}
    public void setErrorHandler(ErrorHandler p0){}
    public void setExpressionFactory(ExpressionFactory p0){}
    public void setLogger(Log p0){}
    public void setUseContextClassLoader(boolean p0){}
    public void setValidating(boolean p0){}
    public void skippedEntity(String p0){}
    public void startDocument(){}
    public void startElement(String p0, String p1, String p2, Attributes p3){}
    public void startPrefixMapping(String p0, String p1){}
    public void unparsedEntityDecl(String p0, String p1, String p2, String p3){}
    public void warning(SAXParseException p0){}
}
