// Generated automatically from org.apache.hadoop.hive.metastore.api.ColumnStatistics for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.ColumnStatisticsDesc;
import org.apache.hadoop.hive.metastore.api.ColumnStatisticsObj;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class ColumnStatistics implements Cloneable, Comparable<ColumnStatistics>, Serializable,
        TBase<ColumnStatistics, ColumnStatistics._Fields> {
    public ColumnStatistics deepCopy() {
        return null;
    }

    public ColumnStatistics() {}

    public ColumnStatistics(ColumnStatistics p0) {}

    public ColumnStatistics(ColumnStatisticsDesc p0, List<ColumnStatisticsObj> p1) {}

    public ColumnStatistics._Fields fieldForId(int p0) {
        return null;
    }

    public ColumnStatisticsDesc getStatsDesc() {
        return null;
    }

    public Iterator<ColumnStatisticsObj> getStatsObjIterator() {
        return null;
    }

    public List<ColumnStatisticsObj> getStatsObj() {
        return null;
    }

    public Object getFieldValue(ColumnStatistics._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(ColumnStatistics p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(ColumnStatistics._Fields p0) {
        return false;
    }

    public boolean isSetStatsDesc() {
        return false;
    }

    public boolean isSetStatsObj() {
        return false;
    }

    public int compareTo(ColumnStatistics p0) {
        return 0;
    }

    public int getStatsObjSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<ColumnStatistics._Fields, FieldMetaData> metaDataMap = null;

    public void addToStatsObj(ColumnStatisticsObj p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(ColumnStatistics._Fields p0, Object p1) {}

    public void setStatsDesc(ColumnStatisticsDesc p0) {}

    public void setStatsDescIsSet(boolean p0) {}

    public void setStatsObj(List<ColumnStatisticsObj> p0) {}

    public void setStatsObjIsSet(boolean p0) {}

    public void unsetStatsDesc() {}

    public void unsetStatsObj() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        STATS_DESC, STATS_OBJ;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static ColumnStatistics._Fields findByName(String p0) {
            return null;
        }

        public static ColumnStatistics._Fields findByThriftId(int p0) {
            return null;
        }

        public static ColumnStatistics._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
