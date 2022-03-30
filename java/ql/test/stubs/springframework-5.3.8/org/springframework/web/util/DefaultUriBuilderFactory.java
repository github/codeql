// Generated automatically from org.springframework.web.util.DefaultUriBuilderFactory for testing purposes

package org.springframework.web.util;

import java.net.URI;
import java.util.Map;
import org.springframework.web.util.UriBuilder;
import org.springframework.web.util.UriBuilderFactory;
import org.springframework.web.util.UriComponentsBuilder;

public class DefaultUriBuilderFactory implements UriBuilderFactory
{
    public DefaultUriBuilderFactory(){}
    public DefaultUriBuilderFactory(String p0){}
    public DefaultUriBuilderFactory(UriComponentsBuilder p0){}
    public DefaultUriBuilderFactory.EncodingMode getEncodingMode(){ return null; }
    public Map<String, ? extends Object> getDefaultUriVariables(){ return null; }
    public URI expand(String p0, Map<String, ? extends Object> p1){ return null; }
    public URI expand(String p0, Object... p1){ return null; }
    public UriBuilder builder(){ return null; }
    public UriBuilder uriString(String p0){ return null; }
    public boolean shouldParsePath(){ return false; }
    public void setDefaultUriVariables(Map<String, ? extends Object> p0){}
    public void setEncodingMode(DefaultUriBuilderFactory.EncodingMode p0){}
    public void setParsePath(boolean p0){}
    static public enum EncodingMode
    {
        NONE, TEMPLATE_AND_VALUES, URI_COMPONENT, VALUES_ONLY;
        private EncodingMode() {}
    }
}
