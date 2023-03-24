// Generated automatically from org.apache.hadoop.hive.metastore.columnstats.aggr.ColumnStatsAggregator for testing purposes

package org.apache.hadoop.hive.metastore.columnstats.aggr;

import java.util.List;
import org.apache.hadoop.hive.metastore.api.ColumnStatisticsObj;
import org.apache.hadoop.hive.metastore.utils.MetaStoreUtils;

abstract public class ColumnStatsAggregator
{
    public ColumnStatsAggregator(){}
    public abstract ColumnStatisticsObj aggregate(List<MetaStoreUtils.ColStatsObjWithSourceInfo> p0, List<String> p1, boolean p2);
    public boolean useDensityFunctionForNDVEstimation = false;
    public double ndvTuner = 0;
}
