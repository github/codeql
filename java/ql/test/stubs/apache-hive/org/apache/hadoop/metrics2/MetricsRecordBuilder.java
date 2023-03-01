// Generated automatically from org.apache.hadoop.metrics2.MetricsRecordBuilder for testing purposes

package org.apache.hadoop.metrics2;

import org.apache.hadoop.metrics2.AbstractMetric;
import org.apache.hadoop.metrics2.MetricsCollector;
import org.apache.hadoop.metrics2.MetricsInfo;
import org.apache.hadoop.metrics2.MetricsTag;

abstract public class MetricsRecordBuilder
{
    public MetricsCollector endRecord(){ return null; }
    public MetricsRecordBuilder(){}
    public abstract MetricsCollector parent();
    public abstract MetricsRecordBuilder add(AbstractMetric p0);
    public abstract MetricsRecordBuilder add(MetricsTag p0);
    public abstract MetricsRecordBuilder addCounter(MetricsInfo p0, int p1);
    public abstract MetricsRecordBuilder addCounter(MetricsInfo p0, long p1);
    public abstract MetricsRecordBuilder addGauge(MetricsInfo p0, double p1);
    public abstract MetricsRecordBuilder addGauge(MetricsInfo p0, float p1);
    public abstract MetricsRecordBuilder addGauge(MetricsInfo p0, int p1);
    public abstract MetricsRecordBuilder addGauge(MetricsInfo p0, long p1);
    public abstract MetricsRecordBuilder setContext(String p0);
    public abstract MetricsRecordBuilder tag(MetricsInfo p0, String p1);
}
