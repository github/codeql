// Generated automatically from org.apache.hadoop.hive.metastore.api.PrivilegeBag for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.HiveObjectPrivilege;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PrivilegeBag implements Cloneable, Comparable<PrivilegeBag>, Serializable,
        TBase<PrivilegeBag, PrivilegeBag._Fields> {
    public Iterator<HiveObjectPrivilege> getPrivilegesIterator() {
        return null;
    }

    public List<HiveObjectPrivilege> getPrivileges() {
        return null;
    }

    public Object getFieldValue(PrivilegeBag._Fields p0) {
        return null;
    }

    public PrivilegeBag deepCopy() {
        return null;
    }

    public PrivilegeBag() {}

    public PrivilegeBag(List<HiveObjectPrivilege> p0) {}

    public PrivilegeBag(PrivilegeBag p0) {}

    public PrivilegeBag._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PrivilegeBag p0) {
        return false;
    }

    public boolean isSet(PrivilegeBag._Fields p0) {
        return false;
    }

    public boolean isSetPrivileges() {
        return false;
    }

    public int compareTo(PrivilegeBag p0) {
        return 0;
    }

    public int getPrivilegesSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PrivilegeBag._Fields, FieldMetaData> metaDataMap = null;

    public void addToPrivileges(HiveObjectPrivilege p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(PrivilegeBag._Fields p0, Object p1) {}

    public void setPrivileges(List<HiveObjectPrivilege> p0) {}

    public void setPrivilegesIsSet(boolean p0) {}

    public void unsetPrivileges() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        PRIVILEGES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PrivilegeBag._Fields findByName(String p0) {
            return null;
        }

        public static PrivilegeBag._Fields findByThriftId(int p0) {
            return null;
        }

        public static PrivilegeBag._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
