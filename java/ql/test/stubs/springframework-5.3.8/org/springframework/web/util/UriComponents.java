// Generated automatically from org.springframework.web.util.UriComponents for testing purposes

package org.springframework.web.util;

import java.io.Serializable;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;
import java.util.function.UnaryOperator;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriComponentsBuilder;

abstract public class UriComponents implements Serializable
{
    protected UriComponents() {}
    abstract UriComponents expandInternal(UriComponents.UriTemplateVariables p0);
    protected UriComponents(String p0, String p1){}
    protected abstract void copyToUriComponentsBuilder(UriComponentsBuilder p0);
    public abstract List<String> getPathSegments();
    public abstract MultiValueMap<String, String> getQueryParams();
    public abstract String getHost();
    public abstract String getPath();
    public abstract String getQuery();
    public abstract String getSchemeSpecificPart();
    public abstract String getUserInfo();
    public abstract String toUriString();
    public abstract URI toUri();
    public abstract UriComponents encode(Charset p0);
    public abstract UriComponents normalize();
    public abstract int getPort();
    public final String getFragment(){ return null; }
    public final String getScheme(){ return null; }
    public final String toString(){ return null; }
    public final UriComponents encode(){ return null; }
    public final UriComponents expand(Map<String, ? extends Object> p0){ return null; }
    public final UriComponents expand(Object... p0){ return null; }
    public final UriComponents expand(UriComponents.UriTemplateVariables p0){ return null; }
    static String expandUriComponent(String p0, UriComponents.UriTemplateVariables p1){ return null; }
    static String expandUriComponent(String p0, UriComponents.UriTemplateVariables p1, UnaryOperator<String> p2){ return null; }
    static public interface UriTemplateVariables
    {
        Object getValue(String p0);
        static Object SKIP_VALUE = null;
    }
}
