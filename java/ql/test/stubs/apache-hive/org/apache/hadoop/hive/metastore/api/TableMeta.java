// Generated automatically from org.apache.hadoop.hive.metastore.api.TableMeta for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class TableMeta implements Cloneable, Comparable<TableMeta>, Serializable,
        TBase<TableMeta, TableMeta._Fields> {
    public Object getFieldValue(TableMeta._Fields p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getComments() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getTableName() {
        return null;
    }

    public String getTableType() {
        return null;
    }

    public String toString() {
        return null;
    }

    public TableMeta deepCopy() {
        return null;
    }

    public TableMeta() {}

    public TableMeta(String p0, String p1, String p2) {}

    public TableMeta(TableMeta p0) {}

    public TableMeta._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(TableMeta p0) {
        return false;
    }

    public boolean isSet(TableMeta._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetComments() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetTableName() {
        return false;
    }

    public boolean isSetTableType() {
        return false;
    }

    public int compareTo(TableMeta p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<TableMeta._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setComments(String p0) {}

    public void setCommentsIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(TableMeta._Fields p0, Object p1) {}

    public void setTableName(String p0) {}

    public void setTableNameIsSet(boolean p0) {}

    public void setTableType(String p0) {}

    public void setTableTypeIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetComments() {}

    public void unsetDbName() {}

    public void unsetTableName() {}

    public void unsetTableType() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, COMMENTS, DB_NAME, TABLE_NAME, TABLE_TYPE;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static TableMeta._Fields findByName(String p0) {
            return null;
        }

        public static TableMeta._Fields findByThriftId(int p0) {
            return null;
        }

        public static TableMeta._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
