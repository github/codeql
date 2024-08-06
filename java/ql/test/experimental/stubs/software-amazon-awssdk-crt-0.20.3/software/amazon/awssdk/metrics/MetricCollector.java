// Generated automatically from software.amazon.awssdk.metrics.MetricCollector for testing purposes

package software.amazon.awssdk.metrics;

import software.amazon.awssdk.metrics.MetricCollection;
import software.amazon.awssdk.metrics.SdkMetric;

public interface MetricCollector
{
    <T> void reportMetric(software.amazon.awssdk.metrics.SdkMetric<T> p0, T p1);
    MetricCollection collect();
    MetricCollector createChild(String p0);
    String name();
    static MetricCollector create(String p0){ return null; }
}
