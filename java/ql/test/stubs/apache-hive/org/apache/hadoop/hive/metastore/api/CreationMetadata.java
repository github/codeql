// Generated automatically from org.apache.hadoop.hive.metastore.api.CreationMetadata for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class CreationMetadata implements Cloneable, Comparable<CreationMetadata>, Serializable,
        TBase<CreationMetadata, CreationMetadata._Fields> {
    public CreationMetadata deepCopy() {
        return null;
    }

    public CreationMetadata() {}

    public CreationMetadata(CreationMetadata p0) {}

    public CreationMetadata(String p0, String p1, String p2, Set<String> p3) {}

    public CreationMetadata._Fields fieldForId(int p0) {
        return null;
    }

    public Iterator<String> getTablesUsedIterator() {
        return null;
    }

    public Object getFieldValue(CreationMetadata._Fields p0) {
        return null;
    }

    public Set<String> getTablesUsed() {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getTblName() {
        return null;
    }

    public String getValidTxnList() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(CreationMetadata p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(CreationMetadata._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetMaterializationTime() {
        return false;
    }

    public boolean isSetTablesUsed() {
        return false;
    }

    public boolean isSetTblName() {
        return false;
    }

    public boolean isSetValidTxnList() {
        return false;
    }

    public int compareTo(CreationMetadata p0) {
        return 0;
    }

    public int getTablesUsedSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getMaterializationTime() {
        return 0;
    }

    public static java.util.Map<CreationMetadata._Fields, FieldMetaData> metaDataMap = null;

    public void addToTablesUsed(String p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(CreationMetadata._Fields p0, Object p1) {}

    public void setMaterializationTime(long p0) {}

    public void setMaterializationTimeIsSet(boolean p0) {}

    public void setTablesUsed(Set<String> p0) {}

    public void setTablesUsedIsSet(boolean p0) {}

    public void setTblName(String p0) {}

    public void setTblNameIsSet(boolean p0) {}

    public void setValidTxnList(String p0) {}

    public void setValidTxnListIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDbName() {}

    public void unsetMaterializationTime() {}

    public void unsetTablesUsed() {}

    public void unsetTblName() {}

    public void unsetValidTxnList() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DB_NAME, MATERIALIZATION_TIME, TABLES_USED, TBL_NAME, VALID_TXN_LIST;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static CreationMetadata._Fields findByName(String p0) {
            return null;
        }

        public static CreationMetadata._Fields findByThriftId(int p0) {
            return null;
        }

        public static CreationMetadata._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
