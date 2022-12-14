// Generated automatically from org.apache.velocity.context.InternalContextBase for testing purposes

package org.apache.velocity.context;

import java.util.List;
import org.apache.velocity.Template;
import org.apache.velocity.app.event.EventCartridge;
import org.apache.velocity.context.InternalEventContext;
import org.apache.velocity.context.InternalHousekeepingContext;
import org.apache.velocity.runtime.resource.Resource;
import org.apache.velocity.util.introspection.IntrospectionCacheData;

class InternalContextBase implements InternalEventContext, InternalHousekeepingContext
{
    public EventCartridge attachEventCartridge(EventCartridge p0){ return null; }
    public EventCartridge getEventCartridge(){ return null; }
    public IntrospectionCacheData icacheGet(Object p0){ return null; }
    public List<Template> getMacroLibraries(){ return null; }
    public Resource getCurrentResource(){ return null; }
    public String getCurrentMacroName(){ return null; }
    public String getCurrentTemplateName(){ return null; }
    public String[] getMacroNameStack(){ return null; }
    public String[] getTemplateNameStack(){ return null; }
    public int getCurrentMacroCallDepth(){ return 0; }
    public void icachePut(Object p0, IntrospectionCacheData p1){}
    public void popCurrentMacroName(){}
    public void popCurrentTemplateName(){}
    public void pushCurrentMacroName(String p0){}
    public void pushCurrentTemplateName(String p0){}
    public void setCurrentResource(Resource p0){}
    public void setMacroLibraries(List<Template> p0){}
}
