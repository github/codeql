// Generated automatically from org.springframework.web.util.AbstractUriTemplateHandler for testing purposes

package org.springframework.web.util;

import java.net.URI;
import java.util.Map;
import org.springframework.web.util.UriTemplateHandler;

abstract public class AbstractUriTemplateHandler implements UriTemplateHandler
{
    protected abstract URI expandInternal(String p0, Map<String, ? extends Object> p1);
    protected abstract URI expandInternal(String p0, Object... p1);
    public AbstractUriTemplateHandler(){}
    public Map<String, ? extends Object> getDefaultUriVariables(){ return null; }
    public String getBaseUrl(){ return null; }
    public URI expand(String p0, Map<String, ? extends Object> p1){ return null; }
    public URI expand(String p0, Object... p1){ return null; }
    public void setBaseUrl(String p0){}
    public void setDefaultUriVariables(Map<String, ? extends Object> p0){}
}
