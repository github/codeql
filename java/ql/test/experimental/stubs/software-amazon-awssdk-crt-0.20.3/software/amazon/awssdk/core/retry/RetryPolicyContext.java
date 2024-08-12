// Generated automatically from software.amazon.awssdk.core.retry.RetryPolicyContext for testing purposes

package software.amazon.awssdk.core.retry;

import software.amazon.awssdk.core.SdkRequest;
import software.amazon.awssdk.core.exception.SdkException;
import software.amazon.awssdk.core.interceptor.ExecutionAttributes;
import software.amazon.awssdk.http.SdkHttpFullRequest;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class RetryPolicyContext implements ToCopyableBuilder<RetryPolicyContext.Builder, RetryPolicyContext>
{
    protected RetryPolicyContext() {}
    public ExecutionAttributes executionAttributes(){ return null; }
    public Integer httpStatusCode(){ return null; }
    public RetryPolicyContext.Builder toBuilder(){ return null; }
    public SdkException exception(){ return null; }
    public SdkHttpFullRequest request(){ return null; }
    public SdkRequest originalRequest(){ return null; }
    public int retriesAttempted(){ return 0; }
    public int totalRequests(){ return 0; }
    public static RetryPolicyContext.Builder builder(){ return null; }
    static public class Builder implements CopyableBuilder<RetryPolicyContext.Builder, RetryPolicyContext>
    {
        protected Builder() {}
        public RetryPolicyContext build(){ return null; }
        public RetryPolicyContext.Builder exception(SdkException p0){ return null; }
        public RetryPolicyContext.Builder executionAttributes(ExecutionAttributes p0){ return null; }
        public RetryPolicyContext.Builder httpStatusCode(Integer p0){ return null; }
        public RetryPolicyContext.Builder originalRequest(SdkRequest p0){ return null; }
        public RetryPolicyContext.Builder request(SdkHttpFullRequest p0){ return null; }
        public RetryPolicyContext.Builder retriesAttempted(int p0){ return null; }
    }
}
