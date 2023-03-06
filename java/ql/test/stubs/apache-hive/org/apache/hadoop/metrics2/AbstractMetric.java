// Generated automatically from org.apache.hadoop.metrics2.AbstractMetric for testing purposes

package org.apache.hadoop.metrics2;

import org.apache.hadoop.metrics2.MetricType;
import org.apache.hadoop.metrics2.MetricsInfo;
import org.apache.hadoop.metrics2.MetricsVisitor;

abstract public class AbstractMetric implements MetricsInfo
{
    protected AbstractMetric() {}
    protected AbstractMetric(MetricsInfo p0){}
    protected MetricsInfo info(){ return null; }
    public String description(){ return null; }
    public String name(){ return null; }
    public String toString(){ return null; }
    public abstract MetricType type();
    public abstract Number value();
    public abstract void visit(MetricsVisitor p0);
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
}
