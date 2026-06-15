// Generated automatically from software.amazon.awssdk.core.client.config.ClientOverrideConfiguration for testing purposes

package software.amazon.awssdk.core.client.config;

import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.client.config.SdkAdvancedClientOption;
import software.amazon.awssdk.core.interceptor.ExecutionAttribute;
import software.amazon.awssdk.core.interceptor.ExecutionAttributes;
import software.amazon.awssdk.core.interceptor.ExecutionInterceptor;
import software.amazon.awssdk.core.retry.RetryMode;
import software.amazon.awssdk.core.retry.RetryPolicy;
import software.amazon.awssdk.metrics.MetricPublisher;
import software.amazon.awssdk.profiles.ProfileFile;
import software.amazon.awssdk.utils.AttributeMap;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ClientOverrideConfiguration implements ToCopyableBuilder<ClientOverrideConfiguration.Builder, ClientOverrideConfiguration>
{
    protected ClientOverrideConfiguration() {}
    public <T> java.util.Optional<T> advancedOption(software.amazon.awssdk.core.client.config.SdkAdvancedClientOption<T> p0){ return null; }
    public ClientOverrideConfiguration.Builder toBuilder(){ return null; }
    public ExecutionAttributes executionAttributes(){ return null; }
    public List<ExecutionInterceptor> executionInterceptors(){ return null; }
    public List<MetricPublisher> metricPublishers(){ return null; }
    public Map<String, List<String>> headers(){ return null; }
    public Optional<Duration> apiCallAttemptTimeout(){ return null; }
    public Optional<Duration> apiCallTimeout(){ return null; }
    public Optional<ProfileFile> defaultProfileFile(){ return null; }
    public Optional<RetryPolicy> retryPolicy(){ return null; }
    public Optional<String> defaultProfileName(){ return null; }
    public String toString(){ return null; }
    public static ClientOverrideConfiguration.Builder builder(){ return null; }
    static public interface Builder extends CopyableBuilder<ClientOverrideConfiguration.Builder, ClientOverrideConfiguration>
    {
        <T> ClientOverrideConfiguration.Builder putAdvancedOption(software.amazon.awssdk.core.client.config.SdkAdvancedClientOption<T> p0, T p1);
        <T> ClientOverrideConfiguration.Builder putExecutionAttribute(software.amazon.awssdk.core.interceptor.ExecutionAttribute<T> p0, T p1);
        AttributeMap advancedOptions();
        ClientOverrideConfiguration.Builder addExecutionInterceptor(ExecutionInterceptor p0);
        ClientOverrideConfiguration.Builder addMetricPublisher(MetricPublisher p0);
        ClientOverrideConfiguration.Builder advancedOptions(Map<SdkAdvancedClientOption<? extends Object>, ? extends Object> p0);
        ClientOverrideConfiguration.Builder apiCallAttemptTimeout(Duration p0);
        ClientOverrideConfiguration.Builder apiCallTimeout(Duration p0);
        ClientOverrideConfiguration.Builder defaultProfileFile(ProfileFile p0);
        ClientOverrideConfiguration.Builder defaultProfileName(String p0);
        ClientOverrideConfiguration.Builder executionAttributes(ExecutionAttributes p0);
        ClientOverrideConfiguration.Builder executionInterceptors(List<ExecutionInterceptor> p0);
        ClientOverrideConfiguration.Builder headers(Map<String, List<String>> p0);
        ClientOverrideConfiguration.Builder metricPublishers(List<MetricPublisher> p0);
        ClientOverrideConfiguration.Builder putHeader(String p0, List<String> p1);
        ClientOverrideConfiguration.Builder retryPolicy(RetryPolicy p0);
        Duration apiCallAttemptTimeout();
        Duration apiCallTimeout();
        ExecutionAttributes executionAttributes();
        List<ExecutionInterceptor> executionInterceptors();
        List<MetricPublisher> metricPublishers();
        Map<String, List<String>> headers();
        ProfileFile defaultProfileFile();
        RetryPolicy retryPolicy();
        String defaultProfileName();
        default ClientOverrideConfiguration.Builder putHeader(String p0, String p1){ return null; }
        default ClientOverrideConfiguration.Builder retryPolicy(RetryMode p0){ return null; }
        default ClientOverrideConfiguration.Builder retryPolicy(java.util.function.Consumer<RetryPolicy.Builder> p0){ return null; }
    }
}
