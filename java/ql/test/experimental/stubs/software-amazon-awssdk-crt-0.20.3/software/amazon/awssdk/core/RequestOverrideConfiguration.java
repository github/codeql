// Generated automatically from software.amazon.awssdk.core.RequestOverrideConfiguration for testing purposes

package software.amazon.awssdk.core;

import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.ApiName;
import software.amazon.awssdk.core.interceptor.ExecutionAttribute;
import software.amazon.awssdk.core.interceptor.ExecutionAttributes;
import software.amazon.awssdk.core.signer.Signer;
import software.amazon.awssdk.metrics.MetricPublisher;

abstract public class RequestOverrideConfiguration
{
    protected RequestOverrideConfiguration() {}
    protected RequestOverrideConfiguration(RequestOverrideConfiguration.Builder<? extends Object> p0){}
    public ExecutionAttributes executionAttributes(){ return null; }
    public List<ApiName> apiNames(){ return null; }
    public List<MetricPublisher> metricPublishers(){ return null; }
    public Map<String, List<String>> headers(){ return null; }
    public Map<String, List<String>> rawQueryParameters(){ return null; }
    public Optional<Duration> apiCallAttemptTimeout(){ return null; }
    public Optional<Duration> apiCallTimeout(){ return null; }
    public Optional<Signer> signer(){ return null; }
    public abstract RequestOverrideConfiguration.Builder<? extends RequestOverrideConfiguration.Builder> toBuilder();
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    static public interface Builder<B extends RequestOverrideConfiguration.Builder>
    {
        <T> B putExecutionAttribute(software.amazon.awssdk.core.interceptor.ExecutionAttribute<T> p0, T p1);
        B addApiName(ApiName p0);
        B addApiName(java.util.function.Consumer<ApiName.Builder> p0);
        B addMetricPublisher(MetricPublisher p0);
        B apiCallAttemptTimeout(Duration p0);
        B apiCallTimeout(Duration p0);
        B executionAttributes(ExecutionAttributes p0);
        B headers(Map<String, List<String>> p0);
        B metricPublishers(List<MetricPublisher> p0);
        B putHeader(String p0, List<String> p1);
        B putRawQueryParameter(String p0, List<String> p1);
        B rawQueryParameters(Map<String, List<String>> p0);
        B signer(Signer p0);
        Duration apiCallAttemptTimeout();
        Duration apiCallTimeout();
        ExecutionAttributes executionAttributes();
        List<ApiName> apiNames();
        List<MetricPublisher> metricPublishers();
        Map<String, List<String>> headers();
        Map<String, List<String>> rawQueryParameters();
        RequestOverrideConfiguration build();
        Signer signer();
        default B putHeader(String p0, String p1){ return null; }
        default B putRawQueryParameter(String p0, String p1){ return null; }
    }
}
