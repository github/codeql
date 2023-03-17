// Generated automatically from org.apache.hadoop.metrics2.MetricsVisitor for testing purposes

package org.apache.hadoop.metrics2;

import org.apache.hadoop.metrics2.MetricsInfo;

public interface MetricsVisitor
{
    void counter(MetricsInfo p0, int p1);
    void counter(MetricsInfo p0, long p1);
    void gauge(MetricsInfo p0, double p1);
    void gauge(MetricsInfo p0, float p1);
    void gauge(MetricsInfo p0, int p1);
    void gauge(MetricsInfo p0, long p1);
}
