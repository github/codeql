// Generated automatically from org.apache.velocity.context.InternalHousekeepingContext for testing purposes

package org.apache.velocity.context;

import java.util.List;
import org.apache.velocity.Template;
import org.apache.velocity.runtime.resource.Resource;
import org.apache.velocity.util.introspection.IntrospectionCacheData;

interface InternalHousekeepingContext
{
    IntrospectionCacheData icacheGet(Object p0);
    List<Template> getMacroLibraries();
    Resource getCurrentResource();
    String getCurrentMacroName();
    String getCurrentTemplateName();
    String[] getMacroNameStack();
    String[] getTemplateNameStack();
    int getCurrentMacroCallDepth();
    void icachePut(Object p0, IntrospectionCacheData p1);
    void popCurrentMacroName();
    void popCurrentTemplateName();
    void pushCurrentMacroName(String p0);
    void pushCurrentTemplateName(String p0);
    void setCurrentResource(Resource p0);
    void setMacroLibraries(List<Template> p0);
}
