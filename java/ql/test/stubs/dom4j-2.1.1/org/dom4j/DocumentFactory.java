// Generated automatically from org.dom4j.DocumentFactory for testing purposes

package org.dom4j;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import org.dom4j.Attribute;
import org.dom4j.CDATA;
import org.dom4j.Comment;
import org.dom4j.Document;
import org.dom4j.DocumentType;
import org.dom4j.Element;
import org.dom4j.Entity;
import org.dom4j.Namespace;
import org.dom4j.NodeFilter;
import org.dom4j.ProcessingInstruction;
import org.dom4j.QName;
import org.dom4j.Text;
import org.dom4j.XPath;
import org.dom4j.rule.Pattern;
import org.dom4j.tree.QNameCache;
import org.jaxen.VariableContext;

public class DocumentFactory implements Serializable
{
    protected QName intern(QName p0){ return null; }
    protected QNameCache cache = null;
    protected QNameCache createQNameCache(){ return null; }
    protected static DocumentFactory createSingleton(String p0){ return null; }
    protected void init(){}
    public Attribute createAttribute(Element p0, QName p1, String p2){ return null; }
    public Attribute createAttribute(Element p0, String p1, String p2){ return null; }
    public CDATA createCDATA(String p0){ return null; }
    public Comment createComment(String p0){ return null; }
    public Document createDocument(){ return null; }
    public Document createDocument(Element p0){ return null; }
    public Document createDocument(String p0){ return null; }
    public DocumentFactory(){}
    public DocumentType createDocType(String p0, String p1, String p2){ return null; }
    public Element createElement(QName p0){ return null; }
    public Element createElement(String p0){ return null; }
    public Element createElement(String p0, String p1){ return null; }
    public Entity createEntity(String p0, String p1){ return null; }
    public List getQNames(){ return null; }
    public Map getXPathNamespaceURIs(){ return null; }
    public Namespace createNamespace(String p0, String p1){ return null; }
    public NodeFilter createXPathFilter(String p0){ return null; }
    public NodeFilter createXPathFilter(String p0, VariableContext p1){ return null; }
    public Pattern createPattern(String p0){ return null; }
    public ProcessingInstruction createProcessingInstruction(String p0, Map p1){ return null; }
    public ProcessingInstruction createProcessingInstruction(String p0, String p1){ return null; }
    public QName createQName(String p0){ return null; }
    public QName createQName(String p0, Namespace p1){ return null; }
    public QName createQName(String p0, String p1){ return null; }
    public QName createQName(String p0, String p1, String p2){ return null; }
    public Text createText(String p0){ return null; }
    public XPath createXPath(String p0){ return null; }
    public XPath createXPath(String p0, VariableContext p1){ return null; }
    public static DocumentFactory getInstance(){ return null; }
    public void setXPathNamespaceURIs(Map p0){}
}
