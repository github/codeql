// Generated automatically from software.amazon.awssdk.core.SdkResponse for testing purposes

package software.amazon.awssdk.core;

import java.util.Optional;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.http.SdkHttpResponse;

abstract public class SdkResponse implements SdkPojo
{
    protected SdkResponse() {}
    protected SdkResponse(SdkResponse.Builder p0){}
    public <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public SdkHttpResponse sdkHttpResponse(){ return null; }
    public abstract SdkResponse.Builder toBuilder();
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    static public interface Builder
    {
        SdkHttpResponse sdkHttpResponse();
        SdkResponse build();
        SdkResponse.Builder sdkHttpResponse(SdkHttpResponse p0);
    }
}
