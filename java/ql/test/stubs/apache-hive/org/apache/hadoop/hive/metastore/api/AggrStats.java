// Generated automatically from org.apache.hadoop.hive.metastore.api.AggrStats for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.ColumnStatisticsObj;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class AggrStats implements Cloneable, Comparable<AggrStats>, Serializable,
        TBase<AggrStats, AggrStats._Fields> {
    public AggrStats deepCopy() {
        return null;
    }

    public AggrStats() {}

    public AggrStats(AggrStats p0) {}

    public AggrStats(List<ColumnStatisticsObj> p0, long p1) {}

    public AggrStats._Fields fieldForId(int p0) {
        return null;
    }

    public Iterator<ColumnStatisticsObj> getColStatsIterator() {
        return null;
    }

    public List<ColumnStatisticsObj> getColStats() {
        return null;
    }

    public Object getFieldValue(AggrStats._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(AggrStats p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(AggrStats._Fields p0) {
        return false;
    }

    public boolean isSetColStats() {
        return false;
    }

    public boolean isSetPartsFound() {
        return false;
    }

    public int compareTo(AggrStats p0) {
        return 0;
    }

    public int getColStatsSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getPartsFound() {
        return 0;
    }

    public static java.util.Map<AggrStats._Fields, FieldMetaData> metaDataMap = null;

    public void addToColStats(ColumnStatisticsObj p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setColStats(List<ColumnStatisticsObj> p0) {}

    public void setColStatsIsSet(boolean p0) {}

    public void setFieldValue(AggrStats._Fields p0, Object p1) {}

    public void setPartsFound(long p0) {}

    public void setPartsFoundIsSet(boolean p0) {}

    public void unsetColStats() {}

    public void unsetPartsFound() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        COL_STATS, PARTS_FOUND;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static AggrStats._Fields findByName(String p0) {
            return null;
        }

        public static AggrStats._Fields findByThriftId(int p0) {
            return null;
        }

        public static AggrStats._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
