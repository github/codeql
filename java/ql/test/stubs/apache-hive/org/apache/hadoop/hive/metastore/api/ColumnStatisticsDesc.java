// Generated automatically from org.apache.hadoop.hive.metastore.api.ColumnStatisticsDesc for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class ColumnStatisticsDesc implements Cloneable, Comparable<ColumnStatisticsDesc>,
        Serializable, TBase<ColumnStatisticsDesc, ColumnStatisticsDesc._Fields> {
    public ColumnStatisticsDesc deepCopy() {
        return null;
    }

    public ColumnStatisticsDesc() {}

    public ColumnStatisticsDesc(ColumnStatisticsDesc p0) {}

    public ColumnStatisticsDesc(boolean p0, String p1, String p2) {}

    public ColumnStatisticsDesc._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(ColumnStatisticsDesc._Fields p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getPartName() {
        return null;
    }

    public String getTableName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(ColumnStatisticsDesc p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isIsTblLevel() {
        return false;
    }

    public boolean isSet(ColumnStatisticsDesc._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetIsTblLevel() {
        return false;
    }

    public boolean isSetLastAnalyzed() {
        return false;
    }

    public boolean isSetPartName() {
        return false;
    }

    public boolean isSetTableName() {
        return false;
    }

    public int compareTo(ColumnStatisticsDesc p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getLastAnalyzed() {
        return 0;
    }

    public static java.util.Map<ColumnStatisticsDesc._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(ColumnStatisticsDesc._Fields p0, Object p1) {}

    public void setIsTblLevel(boolean p0) {}

    public void setIsTblLevelIsSet(boolean p0) {}

    public void setLastAnalyzed(long p0) {}

    public void setLastAnalyzedIsSet(boolean p0) {}

    public void setPartName(String p0) {}

    public void setPartNameIsSet(boolean p0) {}

    public void setTableName(String p0) {}

    public void setTableNameIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDbName() {}

    public void unsetIsTblLevel() {}

    public void unsetLastAnalyzed() {}

    public void unsetPartName() {}

    public void unsetTableName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DB_NAME, IS_TBL_LEVEL, LAST_ANALYZED, PART_NAME, TABLE_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static ColumnStatisticsDesc._Fields findByName(String p0) {
            return null;
        }

        public static ColumnStatisticsDesc._Fields findByThriftId(int p0) {
            return null;
        }

        public static ColumnStatisticsDesc._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
