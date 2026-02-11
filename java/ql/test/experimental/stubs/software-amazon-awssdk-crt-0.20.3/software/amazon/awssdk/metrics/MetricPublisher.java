// Generated automatically from software.amazon.awssdk.metrics.MetricPublisher for testing purposes

package software.amazon.awssdk.metrics;

import software.amazon.awssdk.metrics.MetricCollection;
import software.amazon.awssdk.utils.SdkAutoCloseable;

public interface MetricPublisher extends SdkAutoCloseable
{
    void close();
    void publish(MetricCollection p0);
}
