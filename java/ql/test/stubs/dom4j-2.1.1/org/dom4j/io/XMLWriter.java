// Generated automatically from org.dom4j.io.XMLWriter for testing purposes

package org.dom4j.io;

import java.io.IOException;
import java.io.OutputStream;
import java.io.Writer;
import org.dom4j.Attribute;
import org.dom4j.CDATA;
import org.dom4j.Comment;
import org.dom4j.Document;
import org.dom4j.DocumentType;
import org.dom4j.Element;
import org.dom4j.Entity;
import org.dom4j.Namespace;
import org.dom4j.Node;
import org.dom4j.ProcessingInstruction;
import org.dom4j.Text;
import org.dom4j.io.OutputFormat;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.ext.LexicalHandler;
import org.xml.sax.helpers.XMLFilterImpl;

public class XMLWriter extends XMLFilterImpl implements LexicalHandler
{
    protected OutputFormat getOutputFormat(){ return null; }
    protected String escapeAttributeEntities(String p0){ return null; }
    protected String escapeElementEntities(String p0){ return null; }
    protected Writer createWriter(OutputStream p0, String p1){ return null; }
    protected Writer writer = null;
    protected boolean isExpandEmptyElements(){ return false; }
    protected boolean isNamespaceDeclaration(Namespace p0){ return false; }
    protected boolean preserve = false;
    protected boolean shouldEncodeChar(char p0){ return false; }
    protected final boolean isElementSpacePreserved(Element p0){ return false; }
    protected int defaultMaximumAllowedCharacter(){ return 0; }
    protected int lastOutputNodeType = 0;
    protected static OutputFormat DEFAULT_FORMAT = null;
    protected static String[] LEXICAL_HANDLER_NAMES = null;
    protected void handleException(IOException p0){}
    protected void indent(){}
    protected void installLexicalHandler(){}
    protected void writeAttribute(Attribute p0){}
    protected void writeAttribute(Attributes p0, int p1){}
    protected void writeAttributes(Attributes p0){}
    protected void writeAttributes(Element p0){}
    protected void writeCDATA(String p0){}
    protected void writeClose(String p0){}
    protected void writeComment(String p0){}
    protected void writeDeclaration(){}
    protected void writeDocType(DocumentType p0){}
    protected void writeDocType(String p0, String p1, String p2){}
    protected void writeElement(Element p0){}
    protected void writeElementContent(Element p0){}
    protected void writeEmptyElementClose(String p0){}
    protected void writeEntity(Entity p0){}
    protected void writeEntityRef(String p0){}
    protected void writeEscapeAttributeEntities(String p0){}
    protected void writeNamespace(Namespace p0){}
    protected void writeNamespace(String p0, String p1){}
    protected void writeNamespaces(){}
    protected void writeNode(Node p0){}
    protected void writeNodeText(Node p0){}
    protected void writePrintln(){}
    protected void writeProcessingInstruction(ProcessingInstruction p0){}
    protected void writeString(String p0){}
    public LexicalHandler getLexicalHandler(){ return null; }
    public Object getProperty(String p0){ return null; }
    public XMLWriter(){}
    public XMLWriter(OutputFormat p0){}
    public XMLWriter(OutputStream p0){}
    public XMLWriter(OutputStream p0, OutputFormat p1){}
    public XMLWriter(Writer p0){}
    public XMLWriter(Writer p0, OutputFormat p1){}
    public boolean isEscapeText(){ return false; }
    public boolean resolveEntityRefs(){ return false; }
    public int getMaximumAllowedCharacter(){ return 0; }
    public void characters(char[] p0, int p1, int p2){}
    public void close(){}
    public void comment(char[] p0, int p1, int p2){}
    public void endCDATA(){}
    public void endDTD(){}
    public void endDocument(){}
    public void endElement(String p0, String p1, String p2){}
    public void endEntity(String p0){}
    public void endPrefixMapping(String p0){}
    public void flush(){}
    public void ignorableWhitespace(char[] p0, int p1, int p2){}
    public void notationDecl(String p0, String p1, String p2){}
    public void parse(InputSource p0){}
    public void println(){}
    public void processingInstruction(String p0, String p1){}
    public void setDocumentLocator(Locator p0){}
    public void setEscapeText(boolean p0){}
    public void setIndentLevel(int p0){}
    public void setLexicalHandler(LexicalHandler p0){}
    public void setMaximumAllowedCharacter(int p0){}
    public void setOutputStream(OutputStream p0){}
    public void setProperty(String p0, Object p1){}
    public void setResolveEntityRefs(boolean p0){}
    public void setWriter(Writer p0){}
    public void startCDATA(){}
    public void startDTD(String p0, String p1, String p2){}
    public void startDocument(){}
    public void startElement(String p0, String p1, String p2, Attributes p3){}
    public void startEntity(String p0){}
    public void startPrefixMapping(String p0, String p1){}
    public void unparsedEntityDecl(String p0, String p1, String p2, String p3){}
    public void write(Attribute p0){}
    public void write(CDATA p0){}
    public void write(Comment p0){}
    public void write(Document p0){}
    public void write(DocumentType p0){}
    public void write(Element p0){}
    public void write(Entity p0){}
    public void write(Namespace p0){}
    public void write(Node p0){}
    public void write(Object p0){}
    public void write(ProcessingInstruction p0){}
    public void write(String p0){}
    public void write(Text p0){}
    public void writeClose(Element p0){}
    public void writeOpen(Element p0){}
}
