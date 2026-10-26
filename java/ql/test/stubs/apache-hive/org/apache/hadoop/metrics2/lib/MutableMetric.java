// Generated automatically from org.apache.hadoop.metrics2.lib.MutableMetric for testing purposes

package org.apache.hadoop.metrics2.lib;

import org.apache.hadoop.metrics2.MetricsRecordBuilder;

abstract public class MutableMetric
{
    protected void clearChanged(){}
    protected void setChanged(){}
    public MutableMetric(){}
    public abstract void snapshot(MetricsRecordBuilder p0, boolean p1);
    public boolean changed(){ return false; }
    public void snapshot(MetricsRecordBuilder p0){}
}
