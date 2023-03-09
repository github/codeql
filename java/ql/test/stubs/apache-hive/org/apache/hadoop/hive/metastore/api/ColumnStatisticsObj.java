// Generated automatically from org.apache.hadoop.hive.metastore.api.ColumnStatisticsObj for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.ColumnStatisticsData;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class ColumnStatisticsObj implements Cloneable, Comparable<ColumnStatisticsObj>,
        Serializable, TBase<ColumnStatisticsObj, ColumnStatisticsObj._Fields> {
    public ColumnStatisticsData getStatsData() {
        return null;
    }

    public ColumnStatisticsObj deepCopy() {
        return null;
    }

    public ColumnStatisticsObj() {}

    public ColumnStatisticsObj(ColumnStatisticsObj p0) {}

    public ColumnStatisticsObj(String p0, String p1, ColumnStatisticsData p2) {}

    public ColumnStatisticsObj._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(ColumnStatisticsObj._Fields p0) {
        return null;
    }

    public String getColName() {
        return null;
    }

    public String getColType() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(ColumnStatisticsObj p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(ColumnStatisticsObj._Fields p0) {
        return false;
    }

    public boolean isSetColName() {
        return false;
    }

    public boolean isSetColType() {
        return false;
    }

    public boolean isSetStatsData() {
        return false;
    }

    public int compareTo(ColumnStatisticsObj p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<ColumnStatisticsObj._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setColName(String p0) {}

    public void setColNameIsSet(boolean p0) {}

    public void setColType(String p0) {}

    public void setColTypeIsSet(boolean p0) {}

    public void setFieldValue(ColumnStatisticsObj._Fields p0, Object p1) {}

    public void setStatsData(ColumnStatisticsData p0) {}

    public void setStatsDataIsSet(boolean p0) {}

    public void unsetColName() {}

    public void unsetColType() {}

    public void unsetStatsData() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        COL_NAME, COL_TYPE, STATS_DATA;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static ColumnStatisticsObj._Fields findByName(String p0) {
            return null;
        }

        public static ColumnStatisticsObj._Fields findByThriftId(int p0) {
            return null;
        }

        public static ColumnStatisticsObj._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
