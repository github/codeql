// Generated automatically from org.apache.commons.jelly.JellyContext for testing purposes

package org.apache.commons.jelly;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.util.Iterator;
import java.util.Map;
import org.apache.commons.jelly.Script;
import org.apache.commons.jelly.TagLibrary;
import org.apache.commons.jelly.XMLOutput;
import org.apache.commons.jelly.parser.XMLParser;
import org.xml.sax.InputSource;

public class JellyContext
{
    protected ClassLoader classLoader = null;
    protected JellyContext createChildContext(){ return null; }
    protected URL createRelativeURL(URL p0, String p1){ return null; }
    protected URL getJellyContextURL(InputSource p0){ return null; }
    protected URL getJellyContextURL(URL p0){ return null; }
    protected XMLParser createXMLParser(){ return null; }
    protected XMLParser getXMLParser(){ return null; }
    protected boolean useContextClassLoader = false;
    protected void clearVariables(){}
    protected void setParent(JellyContext p0){}
    public ClassLoader getClassLoader(){ return null; }
    public InputStream getResourceAsStream(String p0){ return null; }
    public Iterator getVariableNames(){ return null; }
    public JellyContext getParent(){ return null; }
    public JellyContext getScope(String p0){ return null; }
    public JellyContext newJellyContext(){ return null; }
    public JellyContext newJellyContext(Map p0){ return null; }
    public JellyContext runScript(File p0, XMLOutput p1){ return null; }
    public JellyContext runScript(File p0, XMLOutput p1, boolean p2, boolean p3){ return null; }
    public JellyContext runScript(InputSource p0, XMLOutput p1){ return null; }
    public JellyContext runScript(InputSource p0, XMLOutput p1, boolean p2, boolean p3){ return null; }
    public JellyContext runScript(String p0, XMLOutput p1){ return null; }
    public JellyContext runScript(String p0, XMLOutput p1, boolean p2, boolean p3){ return null; }
    public JellyContext runScript(URL p0, XMLOutput p1){ return null; }
    public JellyContext runScript(URL p0, XMLOutput p1, boolean p2, boolean p3){ return null; }
    public JellyContext(){}
    public JellyContext(JellyContext p0){}
    public JellyContext(JellyContext p0, URL p1){}
    public JellyContext(JellyContext p0, URL p1, URL p2){}
    public JellyContext(URL p0){}
    public JellyContext(URL p0, URL p1){}
    public Map getVariables(){ return null; }
    public Object findVariable(String p0){ return null; }
    public Object getVariable(String p0){ return null; }
    public Object getVariable(String p0, String p1){ return null; }
    public Script compileScript(InputSource p0){ return null; }
    public Script compileScript(String p0){ return null; }
    public Script compileScript(URL p0){ return null; }
    public TagLibrary getTagLibrary(String p0){ return null; }
    public URL getCurrentURL(){ return null; }
    public URL getResource(String p0){ return null; }
    public URL getRootURL(){ return null; }
    public boolean getUseContextClassLoader(){ return false; }
    public boolean isAllowDtdToCallExternalEntities(){ return false; }
    public boolean isExport(){ return false; }
    public boolean isExportLibraries(){ return false; }
    public boolean isInherit(){ return false; }
    public boolean isTagLibraryRegistered(String p0){ return false; }
    public void clear(){}
    public void registerTagLibrary(String p0, String p1){}
    public void registerTagLibrary(String p0, TagLibrary p1){}
    public void removeVariable(String p0){}
    public void removeVariable(String p0, String p1){}
    public void setAllowDtdToCallExternalEntities(boolean p0){}
    public void setClassLoader(ClassLoader p0){}
    public void setCurrentURL(URL p0){}
    public void setExport(boolean p0){}
    public void setExportLibraries(boolean p0){}
    public void setInherit(boolean p0){}
    public void setRootURL(URL p0){}
    public void setUseContextClassLoader(boolean p0){}
    public void setVariable(String p0, Object p1){}
    public void setVariable(String p0, String p1, Object p2){}
    public void setVariables(Map p0){}
}
