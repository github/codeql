// Generated automatically from org.apache.hadoop.hive.metastore.api.HiveObjectRef for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.HiveObjectType;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class HiveObjectRef implements Cloneable, Comparable<HiveObjectRef>, Serializable,
        TBase<HiveObjectRef, HiveObjectRef._Fields> {
    public HiveObjectRef deepCopy() {
        return null;
    }

    public HiveObjectRef() {}

    public HiveObjectRef(HiveObjectRef p0) {}

    public HiveObjectRef(HiveObjectType p0, String p1, String p2, List<String> p3, String p4) {}

    public HiveObjectRef._Fields fieldForId(int p0) {
        return null;
    }

    public HiveObjectType getObjectType() {
        return null;
    }

    public Iterator<String> getPartValuesIterator() {
        return null;
    }

    public List<String> getPartValues() {
        return null;
    }

    public Object getFieldValue(HiveObjectRef._Fields p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getColumnName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getObjectName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(HiveObjectRef p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(HiveObjectRef._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetColumnName() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetObjectName() {
        return false;
    }

    public boolean isSetObjectType() {
        return false;
    }

    public boolean isSetPartValues() {
        return false;
    }

    public int compareTo(HiveObjectRef p0) {
        return 0;
    }

    public int getPartValuesSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<HiveObjectRef._Fields, FieldMetaData> metaDataMap = null;

    public void addToPartValues(String p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setColumnName(String p0) {}

    public void setColumnNameIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(HiveObjectRef._Fields p0, Object p1) {}

    public void setObjectName(String p0) {}

    public void setObjectNameIsSet(boolean p0) {}

    public void setObjectType(HiveObjectType p0) {}

    public void setObjectTypeIsSet(boolean p0) {}

    public void setPartValues(List<String> p0) {}

    public void setPartValuesIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetColumnName() {}

    public void unsetDbName() {}

    public void unsetObjectName() {}

    public void unsetObjectType() {}

    public void unsetPartValues() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, COLUMN_NAME, DB_NAME, OBJECT_NAME, OBJECT_TYPE, PART_VALUES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static HiveObjectRef._Fields findByName(String p0) {
            return null;
        }

        public static HiveObjectRef._Fields findByThriftId(int p0) {
            return null;
        }

        public static HiveObjectRef._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
