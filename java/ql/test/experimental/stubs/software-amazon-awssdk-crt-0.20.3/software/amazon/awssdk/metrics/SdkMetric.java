// Generated automatically from software.amazon.awssdk.metrics.SdkMetric for testing purposes

package software.amazon.awssdk.metrics;

import java.util.Set;
import software.amazon.awssdk.metrics.MetricCategory;
import software.amazon.awssdk.metrics.MetricLevel;

public interface SdkMetric<T>
{
    MetricLevel level();
    Set<MetricCategory> categories();
    String name();
    java.lang.Class<T> valueClass();
    static <T> software.amazon.awssdk.metrics.SdkMetric<T> create(String p0, java.lang.Class<T> p1, MetricLevel p2, MetricCategory p3, MetricCategory... p4){ return null; }
    static <T> software.amazon.awssdk.metrics.SdkMetric<T> create(String p0, java.lang.Class<T> p1, MetricLevel p2, Set<MetricCategory> p3){ return null; }
}
