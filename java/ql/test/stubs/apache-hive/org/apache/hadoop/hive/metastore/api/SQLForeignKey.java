// Generated automatically from org.apache.hadoop.hive.metastore.api.SQLForeignKey for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class SQLForeignKey implements Cloneable, Comparable<SQLForeignKey>, Serializable,
        TBase<SQLForeignKey, SQLForeignKey._Fields> {
    public Object getFieldValue(SQLForeignKey._Fields p0) {
        return null;
    }

    public SQLForeignKey deepCopy() {
        return null;
    }

    public SQLForeignKey() {}

    public SQLForeignKey(SQLForeignKey p0) {}

    public SQLForeignKey(String p0, String p1, String p2, String p3, String p4, String p5, int p6,
            int p7, int p8, String p9, String p10, boolean p11, boolean p12, boolean p13) {}

    public SQLForeignKey._Fields fieldForId(int p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getFk_name() {
        return null;
    }

    public String getFkcolumn_name() {
        return null;
    }

    public String getFktable_db() {
        return null;
    }

    public String getFktable_name() {
        return null;
    }

    public String getPk_name() {
        return null;
    }

    public String getPkcolumn_name() {
        return null;
    }

    public String getPktable_db() {
        return null;
    }

    public String getPktable_name() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(SQLForeignKey p0) {
        return false;
    }

    public boolean isEnable_cstr() {
        return false;
    }

    public boolean isRely_cstr() {
        return false;
    }

    public boolean isSet(SQLForeignKey._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDelete_rule() {
        return false;
    }

    public boolean isSetEnable_cstr() {
        return false;
    }

    public boolean isSetFk_name() {
        return false;
    }

    public boolean isSetFkcolumn_name() {
        return false;
    }

    public boolean isSetFktable_db() {
        return false;
    }

    public boolean isSetFktable_name() {
        return false;
    }

    public boolean isSetKey_seq() {
        return false;
    }

    public boolean isSetPk_name() {
        return false;
    }

    public boolean isSetPkcolumn_name() {
        return false;
    }

    public boolean isSetPktable_db() {
        return false;
    }

    public boolean isSetPktable_name() {
        return false;
    }

    public boolean isSetRely_cstr() {
        return false;
    }

    public boolean isSetUpdate_rule() {
        return false;
    }

    public boolean isSetValidate_cstr() {
        return false;
    }

    public boolean isValidate_cstr() {
        return false;
    }

    public int compareTo(SQLForeignKey p0) {
        return 0;
    }

    public int getDelete_rule() {
        return 0;
    }

    public int getKey_seq() {
        return 0;
    }

    public int getUpdate_rule() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<SQLForeignKey._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDelete_rule(int p0) {}

    public void setDelete_ruleIsSet(boolean p0) {}

    public void setEnable_cstr(boolean p0) {}

    public void setEnable_cstrIsSet(boolean p0) {}

    public void setFieldValue(SQLForeignKey._Fields p0, Object p1) {}

    public void setFk_name(String p0) {}

    public void setFk_nameIsSet(boolean p0) {}

    public void setFkcolumn_name(String p0) {}

    public void setFkcolumn_nameIsSet(boolean p0) {}

    public void setFktable_db(String p0) {}

    public void setFktable_dbIsSet(boolean p0) {}

    public void setFktable_name(String p0) {}

    public void setFktable_nameIsSet(boolean p0) {}

    public void setKey_seq(int p0) {}

    public void setKey_seqIsSet(boolean p0) {}

    public void setPk_name(String p0) {}

    public void setPk_nameIsSet(boolean p0) {}

    public void setPkcolumn_name(String p0) {}

    public void setPkcolumn_nameIsSet(boolean p0) {}

    public void setPktable_db(String p0) {}

    public void setPktable_dbIsSet(boolean p0) {}

    public void setPktable_name(String p0) {}

    public void setPktable_nameIsSet(boolean p0) {}

    public void setRely_cstr(boolean p0) {}

    public void setRely_cstrIsSet(boolean p0) {}

    public void setUpdate_rule(int p0) {}

    public void setUpdate_ruleIsSet(boolean p0) {}

    public void setValidate_cstr(boolean p0) {}

    public void setValidate_cstrIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDelete_rule() {}

    public void unsetEnable_cstr() {}

    public void unsetFk_name() {}

    public void unsetFkcolumn_name() {}

    public void unsetFktable_db() {}

    public void unsetFktable_name() {}

    public void unsetKey_seq() {}

    public void unsetPk_name() {}

    public void unsetPkcolumn_name() {}

    public void unsetPktable_db() {}

    public void unsetPktable_name() {}

    public void unsetRely_cstr() {}

    public void unsetUpdate_rule() {}

    public void unsetValidate_cstr() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DELETE_RULE, ENABLE_CSTR, FKCOLUMN_NAME, FKTABLE_DB, FKTABLE_NAME, FK_NAME, KEY_SEQ, PKCOLUMN_NAME, PKTABLE_DB, PKTABLE_NAME, PK_NAME, RELY_CSTR, UPDATE_RULE, VALIDATE_CSTR;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static SQLForeignKey._Fields findByName(String p0) {
            return null;
        }

        public static SQLForeignKey._Fields findByThriftId(int p0) {
            return null;
        }

        public static SQLForeignKey._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
