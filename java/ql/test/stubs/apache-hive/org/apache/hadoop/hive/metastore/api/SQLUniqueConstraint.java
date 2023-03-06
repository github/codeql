// Generated automatically from org.apache.hadoop.hive.metastore.api.SQLUniqueConstraint for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class SQLUniqueConstraint implements Cloneable, Comparable<SQLUniqueConstraint>,
        Serializable, TBase<SQLUniqueConstraint, SQLUniqueConstraint._Fields> {
    public Object getFieldValue(SQLUniqueConstraint._Fields p0) {
        return null;
    }

    public SQLUniqueConstraint deepCopy() {
        return null;
    }

    public SQLUniqueConstraint() {}

    public SQLUniqueConstraint(SQLUniqueConstraint p0) {}

    public SQLUniqueConstraint(String p0, String p1, String p2, String p3, int p4, String p5,
            boolean p6, boolean p7, boolean p8) {}

    public SQLUniqueConstraint._Fields fieldForId(int p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getColumn_name() {
        return null;
    }

    public String getTable_db() {
        return null;
    }

    public String getTable_name() {
        return null;
    }

    public String getUk_name() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(SQLUniqueConstraint p0) {
        return false;
    }

    public boolean isEnable_cstr() {
        return false;
    }

    public boolean isRely_cstr() {
        return false;
    }

    public boolean isSet(SQLUniqueConstraint._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetColumn_name() {
        return false;
    }

    public boolean isSetEnable_cstr() {
        return false;
    }

    public boolean isSetKey_seq() {
        return false;
    }

    public boolean isSetRely_cstr() {
        return false;
    }

    public boolean isSetTable_db() {
        return false;
    }

    public boolean isSetTable_name() {
        return false;
    }

    public boolean isSetUk_name() {
        return false;
    }

    public boolean isSetValidate_cstr() {
        return false;
    }

    public boolean isValidate_cstr() {
        return false;
    }

    public int compareTo(SQLUniqueConstraint p0) {
        return 0;
    }

    public int getKey_seq() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<SQLUniqueConstraint._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setColumn_name(String p0) {}

    public void setColumn_nameIsSet(boolean p0) {}

    public void setEnable_cstr(boolean p0) {}

    public void setEnable_cstrIsSet(boolean p0) {}

    public void setFieldValue(SQLUniqueConstraint._Fields p0, Object p1) {}

    public void setKey_seq(int p0) {}

    public void setKey_seqIsSet(boolean p0) {}

    public void setRely_cstr(boolean p0) {}

    public void setRely_cstrIsSet(boolean p0) {}

    public void setTable_db(String p0) {}

    public void setTable_dbIsSet(boolean p0) {}

    public void setTable_name(String p0) {}

    public void setTable_nameIsSet(boolean p0) {}

    public void setUk_name(String p0) {}

    public void setUk_nameIsSet(boolean p0) {}

    public void setValidate_cstr(boolean p0) {}

    public void setValidate_cstrIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetColumn_name() {}

    public void unsetEnable_cstr() {}

    public void unsetKey_seq() {}

    public void unsetRely_cstr() {}

    public void unsetTable_db() {}

    public void unsetTable_name() {}

    public void unsetUk_name() {}

    public void unsetValidate_cstr() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, COLUMN_NAME, ENABLE_CSTR, KEY_SEQ, RELY_CSTR, TABLE_DB, TABLE_NAME, UK_NAME, VALIDATE_CSTR;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static SQLUniqueConstraint._Fields findByName(String p0) {
            return null;
        }

        public static SQLUniqueConstraint._Fields findByThriftId(int p0) {
            return null;
        }

        public static SQLUniqueConstraint._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
