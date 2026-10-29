// Generated automatically from org.apache.hadoop.metrics2.MetricsCollector for testing purposes

package org.apache.hadoop.metrics2;

import org.apache.hadoop.metrics2.MetricsInfo;
import org.apache.hadoop.metrics2.MetricsRecordBuilder;

public interface MetricsCollector
{
    MetricsRecordBuilder addRecord(MetricsInfo p0);
    MetricsRecordBuilder addRecord(String p0);
}
