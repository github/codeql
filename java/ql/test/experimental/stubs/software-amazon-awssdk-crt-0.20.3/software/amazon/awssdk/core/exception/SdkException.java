// Generated automatically from software.amazon.awssdk.core.exception.SdkException for testing purposes

package software.amazon.awssdk.core.exception;

import software.amazon.awssdk.utils.builder.Buildable;

public class SdkException extends RuntimeException
{
    protected SdkException() {}
    protected SdkException(SdkException.Builder p0){}
    public SdkException.Builder toBuilder(){ return null; }
    public boolean retryable(){ return false; }
    public static SdkException create(String p0, Throwable p1){ return null; }
    public static SdkException.Builder builder(){ return null; }
    static public interface Builder extends Buildable
    {
        Boolean writableStackTrace();
        SdkException build();
        SdkException.Builder cause(Throwable p0);
        SdkException.Builder message(String p0);
        SdkException.Builder writableStackTrace(Boolean p0);
        String message();
        Throwable cause();
    }
}
