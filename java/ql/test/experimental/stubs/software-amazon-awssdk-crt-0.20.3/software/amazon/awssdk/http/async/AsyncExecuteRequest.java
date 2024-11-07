// Generated automatically from software.amazon.awssdk.http.async.AsyncExecuteRequest for testing purposes

package software.amazon.awssdk.http.async;

import java.util.Optional;
import software.amazon.awssdk.http.SdkHttpExecutionAttribute;
import software.amazon.awssdk.http.SdkHttpExecutionAttributes;
import software.amazon.awssdk.http.SdkHttpRequest;
import software.amazon.awssdk.http.async.SdkAsyncHttpResponseHandler;
import software.amazon.awssdk.http.async.SdkHttpContentPublisher;
import software.amazon.awssdk.metrics.MetricCollector;

public class AsyncExecuteRequest
{
    protected AsyncExecuteRequest() {}
    public Optional<MetricCollector> metricCollector(){ return null; }
    public SdkAsyncHttpResponseHandler responseHandler(){ return null; }
    public SdkHttpContentPublisher requestContentPublisher(){ return null; }
    public SdkHttpExecutionAttributes httpExecutionAttributes(){ return null; }
    public SdkHttpRequest request(){ return null; }
    public boolean fullDuplex(){ return false; }
    public static AsyncExecuteRequest.Builder builder(){ return null; }
    static public interface Builder
    {
        <T> AsyncExecuteRequest.Builder putHttpExecutionAttribute(software.amazon.awssdk.http.SdkHttpExecutionAttribute<T> p0, T p1);
        AsyncExecuteRequest build();
        AsyncExecuteRequest.Builder fullDuplex(boolean p0);
        AsyncExecuteRequest.Builder httpExecutionAttributes(SdkHttpExecutionAttributes p0);
        AsyncExecuteRequest.Builder metricCollector(MetricCollector p0);
        AsyncExecuteRequest.Builder request(SdkHttpRequest p0);
        AsyncExecuteRequest.Builder requestContentPublisher(SdkHttpContentPublisher p0);
        AsyncExecuteRequest.Builder responseHandler(SdkAsyncHttpResponseHandler p0);
    }
}
