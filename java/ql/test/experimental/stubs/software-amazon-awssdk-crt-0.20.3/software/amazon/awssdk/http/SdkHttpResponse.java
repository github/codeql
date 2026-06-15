// Generated automatically from software.amazon.awssdk.http.SdkHttpResponse for testing purposes

package software.amazon.awssdk.http;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import software.amazon.awssdk.http.SdkHttpFullResponse;
import software.amazon.awssdk.http.SdkHttpHeaders;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public interface SdkHttpResponse extends SdkHttpHeaders, Serializable, ToCopyableBuilder<SdkHttpResponse.Builder, SdkHttpResponse>
{
    Optional<String> statusText();
    default boolean isSuccessful(){ return false; }
    int statusCode();
    static SdkHttpFullResponse.Builder builder(){ return null; }
    static public interface Builder extends CopyableBuilder<SdkHttpResponse.Builder, SdkHttpResponse>, SdkHttpHeaders
    {
        Map<String, List<String>> headers();
        SdkHttpResponse.Builder appendHeader(String p0, String p1);
        SdkHttpResponse.Builder clearHeaders();
        SdkHttpResponse.Builder headers(Map<String, List<String>> p0);
        SdkHttpResponse.Builder putHeader(String p0, List<String> p1);
        SdkHttpResponse.Builder removeHeader(String p0);
        SdkHttpResponse.Builder statusCode(int p0);
        SdkHttpResponse.Builder statusText(String p0);
        String statusText();
        default SdkHttpResponse.Builder putHeader(String p0, String p1){ return null; }
        int statusCode();
    }
}
