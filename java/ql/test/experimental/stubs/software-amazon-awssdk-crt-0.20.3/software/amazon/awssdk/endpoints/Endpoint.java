// Generated automatically from software.amazon.awssdk.endpoints.Endpoint for testing purposes

package software.amazon.awssdk.endpoints;

import java.net.URI;
import java.util.List;
import java.util.Map;
import software.amazon.awssdk.endpoints.EndpointAttributeKey;

public class Endpoint
{
    protected Endpoint() {}
    public <T> T attribute(software.amazon.awssdk.endpoints.EndpointAttributeKey<T> p0){ return null; }
    public Endpoint.Builder toBuilder(){ return null; }
    public Map<String, List<String>> headers(){ return null; }
    public URI url(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static Endpoint.Builder builder(){ return null; }
    static public interface Builder
    {
        <T> Endpoint.Builder putAttribute(software.amazon.awssdk.endpoints.EndpointAttributeKey<T> p0, T p1);
        Endpoint build();
        Endpoint.Builder putHeader(String p0, String p1);
        Endpoint.Builder url(URI p0);
    }
}
