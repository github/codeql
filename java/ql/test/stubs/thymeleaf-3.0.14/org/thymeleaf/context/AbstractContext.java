// Generated automatically from org.thymeleaf.context.AbstractContext for testing purposes

package org.thymeleaf.context;

import java.util.Locale;
import java.util.Map;
import java.util.Set;
import org.thymeleaf.context.IContext;

abstract public class AbstractContext implements IContext
{
    protected AbstractContext(){}
    protected AbstractContext(Locale p0){}
    protected AbstractContext(Locale p0, Map<String, Object> p1){}
    public final Locale getLocale(){ return null; }
    public final Object getVariable(String p0){ return null; }
    public final Set<String> getVariableNames(){ return null; }
    public final boolean containsVariable(String p0){ return false; }
    public void clearVariables(){}
    public void removeVariable(String p0){}
    public void setLocale(Locale p0){}
    public void setVariable(String p0, Object p1){}
    public void setVariables(Map<String, Object> p0){}
}
