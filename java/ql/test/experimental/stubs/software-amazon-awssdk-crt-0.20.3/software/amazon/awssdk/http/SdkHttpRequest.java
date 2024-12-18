// Generated automatically from software.amazon.awssdk.http.SdkHttpRequest for testing purposes

package software.amazon.awssdk.http;

import java.net.URI;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.BiConsumer;
import software.amazon.awssdk.http.SdkHttpHeaders;
import software.amazon.awssdk.http.SdkHttpMethod;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public interface SdkHttpRequest extends SdkHttpHeaders, ToCopyableBuilder<SdkHttpRequest.Builder, SdkHttpRequest>
{
    Map<String, List<String>> rawQueryParameters();
    SdkHttpMethod method();
    String encodedPath();
    String host();
    String protocol();
    default List<String> firstMatchingRawQueryParameters(String p0){ return null; }
    default Optional<String> encodedQueryParameters(){ return null; }
    default Optional<String> encodedQueryParametersAsFormData(){ return null; }
    default Optional<String> firstMatchingRawQueryParameter(Collection<String> p0){ return null; }
    default Optional<String> firstMatchingRawQueryParameter(String p0){ return null; }
    default URI getUri(){ return null; }
    default int numRawQueryParameters(){ return 0; }
    default void forEachRawQueryParameter(BiConsumer<? super String, ? super List<String>> p0){}
    int port();
    static SdkHttpRequest.Builder builder(){ return null; }
    static public interface Builder extends CopyableBuilder<SdkHttpRequest.Builder, SdkHttpRequest>, SdkHttpHeaders
    {
        Integer port();
        Map<String, List<String>> headers();
        Map<String, List<String>> rawQueryParameters();
        SdkHttpMethod method();
        SdkHttpRequest.Builder appendHeader(String p0, String p1);
        SdkHttpRequest.Builder appendRawQueryParameter(String p0, String p1);
        SdkHttpRequest.Builder clearHeaders();
        SdkHttpRequest.Builder clearQueryParameters();
        SdkHttpRequest.Builder encodedPath(String p0);
        SdkHttpRequest.Builder headers(Map<String, List<String>> p0);
        SdkHttpRequest.Builder host(String p0);
        SdkHttpRequest.Builder method(SdkHttpMethod p0);
        SdkHttpRequest.Builder port(Integer p0);
        SdkHttpRequest.Builder protocol(String p0);
        SdkHttpRequest.Builder putHeader(String p0, List<String> p1);
        SdkHttpRequest.Builder putRawQueryParameter(String p0, List<String> p1);
        SdkHttpRequest.Builder rawQueryParameters(Map<String, List<String>> p0);
        SdkHttpRequest.Builder removeHeader(String p0);
        SdkHttpRequest.Builder removeQueryParameter(String p0);
        String encodedPath();
        String host();
        String protocol();
        default Optional<String> encodedQueryParameters(){ return null; }
        default SdkHttpRequest.Builder putHeader(String p0, String p1){ return null; }
        default SdkHttpRequest.Builder putRawQueryParameter(String p0, String p1){ return null; }
        default SdkHttpRequest.Builder uri(URI p0){ return null; }
        default int numRawQueryParameters(){ return 0; }
        default void forEachRawQueryParameter(BiConsumer<? super String, ? super List<String>> p0){}
    }
}
