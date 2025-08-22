// Generated automatically from software.amazon.awssdk.metrics.MetricCollection for testing purposes

package software.amazon.awssdk.metrics;

import java.time.Instant;
import java.util.List;
import java.util.stream.Stream;
import software.amazon.awssdk.metrics.MetricRecord;
import software.amazon.awssdk.metrics.SdkMetric;

public interface MetricCollection extends Iterable<MetricRecord<? extends Object>>
{
    <T> java.util.List<T> metricValues(software.amazon.awssdk.metrics.SdkMetric<T> p0);
    Instant creationTime();
    List<MetricCollection> children();
    String name();
    default Stream<MetricCollection> childrenWithName(String p0){ return null; }
    default Stream<MetricRecord<? extends Object>> stream(){ return null; }
}
