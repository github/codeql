// Generated automatically from software.amazon.awssdk.http.SdkHttpFullResponse for testing purposes

package software.amazon.awssdk.http;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import software.amazon.awssdk.http.AbortableInputStream;
import software.amazon.awssdk.http.SdkHttpResponse;

public interface SdkHttpFullResponse extends SdkHttpResponse
{
    Optional<AbortableInputStream> content();
    SdkHttpFullResponse.Builder toBuilder();
    static SdkHttpFullResponse.Builder builder(){ return null; }
    static public interface Builder extends SdkHttpResponse.Builder
    {
        AbortableInputStream content();
        Map<String, List<String>> headers();
        SdkHttpFullResponse build();
        SdkHttpFullResponse.Builder appendHeader(String p0, String p1);
        SdkHttpFullResponse.Builder clearHeaders();
        SdkHttpFullResponse.Builder content(AbortableInputStream p0);
        SdkHttpFullResponse.Builder headers(Map<String, List<String>> p0);
        SdkHttpFullResponse.Builder putHeader(String p0, List<String> p1);
        SdkHttpFullResponse.Builder removeHeader(String p0);
        SdkHttpFullResponse.Builder statusCode(int p0);
        SdkHttpFullResponse.Builder statusText(String p0);
        String statusText();
        default SdkHttpFullResponse.Builder putHeader(String p0, String p1){ return null; }
        int statusCode();
    }
}
