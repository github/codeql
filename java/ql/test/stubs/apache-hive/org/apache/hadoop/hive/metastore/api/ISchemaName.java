// Generated automatically from org.apache.hadoop.hive.metastore.api.ISchemaName for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class ISchemaName implements Cloneable, Comparable<ISchemaName>, Serializable,
        TBase<ISchemaName, ISchemaName._Fields> {
    public ISchemaName deepCopy() {
        return null;
    }

    public ISchemaName() {}

    public ISchemaName(ISchemaName p0) {}

    public ISchemaName(String p0, String p1, String p2) {}

    public ISchemaName._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(ISchemaName._Fields p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getSchemaName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(ISchemaName p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(ISchemaName._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetSchemaName() {
        return false;
    }

    public int compareTo(ISchemaName p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<ISchemaName._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(ISchemaName._Fields p0, Object p1) {}

    public void setSchemaName(String p0) {}

    public void setSchemaNameIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDbName() {}

    public void unsetSchemaName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DB_NAME, SCHEMA_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static ISchemaName._Fields findByName(String p0) {
            return null;
        }

        public static ISchemaName._Fields findByThriftId(int p0) {
            return null;
        }

        public static ISchemaName._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
