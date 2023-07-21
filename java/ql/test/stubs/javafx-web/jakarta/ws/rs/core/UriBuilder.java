// Generated automatically from jakarta.ws.rs.core.UriBuilder for testing purposes

package jakarta.ws.rs.core;

import jakarta.ws.rs.core.Link;
import java.lang.reflect.Method;
import java.net.URI;
import java.util.Map;

abstract public class UriBuilder
{
    protected UriBuilder(){}
    public abstract String toTemplate();
    public abstract URI build(Object... p0);
    public abstract URI build(Object[] p0, boolean p1);
    public abstract URI buildFromEncoded(Object... p0);
    public abstract URI buildFromEncodedMap(Map<String, ? extends Object> p0);
    public abstract URI buildFromMap(Map<String, ? extends Object> p0);
    public abstract URI buildFromMap(Map<String, ? extends Object> p0, boolean p1);
    public abstract UriBuilder clone();
    public abstract UriBuilder fragment(String p0);
    public abstract UriBuilder host(String p0);
    public abstract UriBuilder matrixParam(String p0, Object... p1);
    public abstract UriBuilder path(Class p0);
    public abstract UriBuilder path(Class p0, String p1);
    public abstract UriBuilder path(Method p0);
    public abstract UriBuilder path(String p0);
    public abstract UriBuilder port(int p0);
    public abstract UriBuilder queryParam(String p0, Object... p1);
    public abstract UriBuilder replaceMatrix(String p0);
    public abstract UriBuilder replaceMatrixParam(String p0, Object... p1);
    public abstract UriBuilder replacePath(String p0);
    public abstract UriBuilder replaceQuery(String p0);
    public abstract UriBuilder replaceQueryParam(String p0, Object... p1);
    public abstract UriBuilder resolveTemplate(String p0, Object p1);
    public abstract UriBuilder resolveTemplate(String p0, Object p1, boolean p2);
    public abstract UriBuilder resolveTemplateFromEncoded(String p0, Object p1);
    public abstract UriBuilder resolveTemplates(Map<String, Object> p0);
    public abstract UriBuilder resolveTemplates(Map<String, Object> p0, boolean p1);
    public abstract UriBuilder resolveTemplatesFromEncoded(Map<String, Object> p0);
    public abstract UriBuilder scheme(String p0);
    public abstract UriBuilder schemeSpecificPart(String p0);
    public abstract UriBuilder segment(String... p0);
    public abstract UriBuilder uri(String p0);
    public abstract UriBuilder uri(URI p0);
    public abstract UriBuilder userInfo(String p0);
    public static UriBuilder fromLink(Link p0){ return null; }
    public static UriBuilder fromMethod(Class<? extends Object> p0, String p1){ return null; }
    public static UriBuilder fromPath(String p0){ return null; }
    public static UriBuilder fromResource(Class<? extends Object> p0){ return null; }
    public static UriBuilder fromUri(String p0){ return null; }
    public static UriBuilder fromUri(URI p0){ return null; }
    public static UriBuilder newInstance(){ return null; }
}
