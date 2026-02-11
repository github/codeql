// Generated automatically from software.amazon.awssdk.http.SdkHttpFullRequest for testing purposes

package software.amazon.awssdk.http;

import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.http.ContentStreamProvider;
import software.amazon.awssdk.http.SdkHttpMethod;
import software.amazon.awssdk.http.SdkHttpRequest;

public interface SdkHttpFullRequest extends SdkHttpRequest
{
    Optional<ContentStreamProvider> contentStreamProvider();
    SdkHttpFullRequest.Builder toBuilder();
    static SdkHttpFullRequest.Builder builder(){ return null; }
    static public interface Builder extends SdkHttpRequest.Builder
    {
        ContentStreamProvider contentStreamProvider();
        Integer port();
        Map<String, List<String>> headers();
        Map<String, List<String>> rawQueryParameters();
        SdkHttpFullRequest build();
        SdkHttpFullRequest.Builder appendHeader(String p0, String p1);
        SdkHttpFullRequest.Builder appendRawQueryParameter(String p0, String p1);
        SdkHttpFullRequest.Builder applyMutation(java.util.function.Consumer<SdkHttpRequest.Builder> p0);
        SdkHttpFullRequest.Builder clearHeaders();
        SdkHttpFullRequest.Builder clearQueryParameters();
        SdkHttpFullRequest.Builder contentStreamProvider(ContentStreamProvider p0);
        SdkHttpFullRequest.Builder copy();
        SdkHttpFullRequest.Builder encodedPath(String p0);
        SdkHttpFullRequest.Builder headers(Map<String, List<String>> p0);
        SdkHttpFullRequest.Builder host(String p0);
        SdkHttpFullRequest.Builder method(SdkHttpMethod p0);
        SdkHttpFullRequest.Builder port(Integer p0);
        SdkHttpFullRequest.Builder protocol(String p0);
        SdkHttpFullRequest.Builder putHeader(String p0, List<String> p1);
        SdkHttpFullRequest.Builder putRawQueryParameter(String p0, List<String> p1);
        SdkHttpFullRequest.Builder rawQueryParameters(Map<String, List<String>> p0);
        SdkHttpFullRequest.Builder removeHeader(String p0);
        SdkHttpFullRequest.Builder removeQueryParameter(String p0);
        SdkHttpMethod method();
        String encodedPath();
        String host();
        String protocol();
        default SdkHttpFullRequest.Builder putHeader(String p0, String p1){ return null; }
        default SdkHttpFullRequest.Builder putRawQueryParameter(String p0, String p1){ return null; }
        default SdkHttpFullRequest.Builder uri(URI p0){ return null; }
    }
}
