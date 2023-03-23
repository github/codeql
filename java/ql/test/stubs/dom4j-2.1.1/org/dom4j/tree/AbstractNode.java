// Generated automatically from org.dom4j.tree.AbstractNode for testing purposes

package org.dom4j.tree;

import java.io.Serializable;
import java.io.Writer;
import java.util.List;
import org.dom4j.Document;
import org.dom4j.DocumentFactory;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.NodeFilter;
import org.dom4j.XPath;
import org.dom4j.rule.Pattern;

abstract public class AbstractNode implements Cloneable, Node, Serializable
{
    protected DocumentFactory getDocumentFactory(){ return null; }
    protected Node createXPathResult(Element p0){ return null; }
    protected static String[] NODE_TYPE_NAMES = null;
    public AbstractNode(){}
    public Document getDocument(){ return null; }
    public Element getParent(){ return null; }
    public List selectNodes(String p0){ return null; }
    public List selectNodes(String p0, String p1){ return null; }
    public List selectNodes(String p0, String p1, boolean p2){ return null; }
    public Node asXPathResult(Element p0){ return null; }
    public Node detach(){ return null; }
    public Node selectSingleNode(String p0){ return null; }
    public NodeFilter createXPathFilter(String p0){ return null; }
    public Number numberValueOf(String p0){ return null; }
    public Object clone(){ return null; }
    public Object selectObject(String p0){ return null; }
    public Pattern createPattern(String p0){ return null; }
    public String getName(){ return null; }
    public String getNodeTypeName(){ return null; }
    public String getPath(){ return null; }
    public String getStringValue(){ return null; }
    public String getText(){ return null; }
    public String getUniquePath(){ return null; }
    public String valueOf(String p0){ return null; }
    public XPath createXPath(String p0){ return null; }
    public boolean hasContent(){ return false; }
    public boolean isReadOnly(){ return false; }
    public boolean matches(String p0){ return false; }
    public boolean supportsParent(){ return false; }
    public short getNodeType(){ return 0; }
    public void setDocument(Document p0){}
    public void setName(String p0){}
    public void setParent(Element p0){}
    public void setText(String p0){}
    public void write(Writer p0){}
}
