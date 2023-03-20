// Generated automatically from org.apache.commons.jelly.impl.TagScript for testing purposes

package org.apache.commons.jelly.impl;

import java.util.Map;
import org.apache.commons.jelly.JellyContext;
import org.apache.commons.jelly.JellyException;
import org.apache.commons.jelly.JellyTagException;
import org.apache.commons.jelly.LocationAware;
import org.apache.commons.jelly.Script;
import org.apache.commons.jelly.Tag;
import org.apache.commons.jelly.XMLOutput;
import org.apache.commons.jelly.expression.Expression;
import org.apache.commons.jelly.impl.TagFactory;
import org.xml.sax.Attributes;
import org.xml.sax.Locator;

public class TagScript implements Script
{
    protected JellyException createJellyException(String p0){ return null; }
    protected JellyException createJellyException(String p0, Exception p1){ return null; }
    protected Map attributes = null;
    protected Object convertType(Object p0, Class p1){ return null; }
    protected Tag createTag(){ return null; }
    protected void applyLocation(LocationAware p0){}
    protected void configureTag(Tag p0, JellyContext p1){}
    protected void endNamespacePrefixes(XMLOutput p0){}
    protected void handleException(Error p0){}
    protected void handleException(Exception p0){}
    protected void handleException(JellyException p0){}
    protected void handleException(JellyTagException p0){}
    protected void setContextURLs(JellyContext p0){}
    protected void setTag(Tag p0, JellyContext p1){}
    protected void startNamespacePrefixes(XMLOutput p0){}
    public Attributes getSaxAttributes(){ return null; }
    public Map getNamespaceContext(){ return null; }
    public Script compile(){ return null; }
    public Script getTagBody(){ return null; }
    public String getElementName(){ return null; }
    public String getFileName(){ return null; }
    public String getLocalName(){ return null; }
    public String toString(){ return null; }
    public Tag getTag(JellyContext p0){ return null; }
    public TagFactory getTagFactory(){ return null; }
    public TagScript getParent(){ return null; }
    public TagScript(){}
    public TagScript(TagFactory p0){}
    public int getColumnNumber(){ return 0; }
    public int getLineNumber(){ return 0; }
    public static TagScript newInstance(Class p0){ return null; }
    public void addAttribute(String p0, Expression p1){}
    public void run(JellyContext p0, XMLOutput p1){}
    public void setColumnNumber(int p0){}
    public void setElementName(String p0){}
    public void setFileName(String p0){}
    public void setLineNumber(int p0){}
    public void setLocalName(String p0){}
    public void setLocator(Locator p0){}
    public void setParent(TagScript p0){}
    public void setSaxAttributes(Attributes p0){}
    public void setTagBody(Script p0){}
    public void setTagFactory(TagFactory p0){}
    public void setTagNamespacesMap(Map p0){}
}
