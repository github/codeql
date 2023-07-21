// Generated automatically from javax.ws.rs.core.Link for testing purposes

package javax.ws.rs.core;

import java.net.URI;
import java.util.List;
import java.util.Map;
import javax.ws.rs.core.UriBuilder;

abstract public class Link
{
    public Link(){}
    public abstract List<String> getRels();
    public abstract Map<String, String> getParams();
    public abstract String getRel();
    public abstract String getTitle();
    public abstract String getType();
    public abstract String toString();
    public abstract URI getUri();
    public abstract UriBuilder getUriBuilder();
    public static Link valueOf(String p0){ return null; }
    public static Link.Builder fromLink(Link p0){ return null; }
    public static Link.Builder fromMethod(Class<? extends Object> p0, String p1){ return null; }
    public static Link.Builder fromPath(String p0){ return null; }
    public static Link.Builder fromResource(Class<? extends Object> p0){ return null; }
    public static Link.Builder fromUri(String p0){ return null; }
    public static Link.Builder fromUri(URI p0){ return null; }
    public static Link.Builder fromUriBuilder(UriBuilder p0){ return null; }
    public static String REL = null;
    public static String TITLE = null;
    public static String TYPE = null;
    static public interface Builder
    {
        Link build(Object... p0);
        Link buildRelativized(URI p0, Object... p1);
        Link.Builder baseUri(String p0);
        Link.Builder baseUri(URI p0);
        Link.Builder link(Link p0);
        Link.Builder link(String p0);
        Link.Builder param(String p0, String p1);
        Link.Builder rel(String p0);
        Link.Builder title(String p0);
        Link.Builder type(String p0);
        Link.Builder uri(String p0);
        Link.Builder uri(URI p0);
        Link.Builder uriBuilder(UriBuilder p0);
    }
}
