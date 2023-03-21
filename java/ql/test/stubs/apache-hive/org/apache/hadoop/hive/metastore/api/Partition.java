// Generated automatically from org.apache.hadoop.hive.metastore.api.Partition for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PrincipalPrivilegeSet;
import org.apache.hadoop.hive.metastore.api.StorageDescriptor;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Partition implements Cloneable, Comparable<Partition>, Serializable,
        TBase<Partition, Partition._Fields> {
    public Iterator<String> getValuesIterator() {
        return null;
    }

    public List<String> getValues() {
        return null;
    }

    public Map<String, String> getParameters() {
        return null;
    }

    public Object getFieldValue(Partition._Fields p0) {
        return null;
    }

    public Partition deepCopy() {
        return null;
    }

    public Partition() {}

    public Partition(List<String> p0, String p1, String p2, int p3, int p4, StorageDescriptor p5,
            Map<String, String> p6) {}

    public Partition(Partition p0) {}

    public Partition._Fields fieldForId(int p0) {
        return null;
    }

    public PrincipalPrivilegeSet getPrivileges() {
        return null;
    }

    public StorageDescriptor getSd() {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getTableName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(Partition p0) {
        return false;
    }

    public boolean isSet(Partition._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetCreateTime() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetLastAccessTime() {
        return false;
    }

    public boolean isSetParameters() {
        return false;
    }

    public boolean isSetPrivileges() {
        return false;
    }

    public boolean isSetSd() {
        return false;
    }

    public boolean isSetTableName() {
        return false;
    }

    public boolean isSetValues() {
        return false;
    }

    public int compareTo(Partition p0) {
        return 0;
    }

    public int getCreateTime() {
        return 0;
    }

    public int getLastAccessTime() {
        return 0;
    }

    public int getParametersSize() {
        return 0;
    }

    public int getValuesSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Partition._Fields, FieldMetaData> metaDataMap = null;

    public void addToValues(String p0) {}

    public void clear() {}

    public void putToParameters(String p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setCreateTime(int p0) {}

    public void setCreateTimeIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(Partition._Fields p0, Object p1) {}

    public void setLastAccessTime(int p0) {}

    public void setLastAccessTimeIsSet(boolean p0) {}

    public void setParameters(Map<String, String> p0) {}

    public void setParametersIsSet(boolean p0) {}

    public void setPrivileges(PrincipalPrivilegeSet p0) {}

    public void setPrivilegesIsSet(boolean p0) {}

    public void setSd(StorageDescriptor p0) {}

    public void setSdIsSet(boolean p0) {}

    public void setTableName(String p0) {}

    public void setTableNameIsSet(boolean p0) {}

    public void setValues(List<String> p0) {}

    public void setValuesIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetCreateTime() {}

    public void unsetDbName() {}

    public void unsetLastAccessTime() {}

    public void unsetParameters() {}

    public void unsetPrivileges() {}

    public void unsetSd() {}

    public void unsetTableName() {}

    public void unsetValues() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, CREATE_TIME, DB_NAME, LAST_ACCESS_TIME, PARAMETERS, PRIVILEGES, SD, TABLE_NAME, VALUES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Partition._Fields findByName(String p0) {
            return null;
        }

        public static Partition._Fields findByThriftId(int p0) {
            return null;
        }

        public static Partition._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
