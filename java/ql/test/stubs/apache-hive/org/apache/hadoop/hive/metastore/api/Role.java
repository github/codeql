// Generated automatically from org.apache.hadoop.hive.metastore.api.Role for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Role implements Cloneable, Comparable<Role>, Serializable, TBase<Role, Role._Fields> {
    public Object getFieldValue(Role._Fields p0) {
        return null;
    }

    public Role deepCopy() {
        return null;
    }

    public Role() {}

    public Role(Role p0) {}

    public Role(String p0, int p1, String p2) {}

    public Role._Fields fieldForId(int p0) {
        return null;
    }

    public String getOwnerName() {
        return null;
    }

    public String getRoleName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(Role p0) {
        return false;
    }

    public boolean isSet(Role._Fields p0) {
        return false;
    }

    public boolean isSetCreateTime() {
        return false;
    }

    public boolean isSetOwnerName() {
        return false;
    }

    public boolean isSetRoleName() {
        return false;
    }

    public int compareTo(Role p0) {
        return 0;
    }

    public int getCreateTime() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Role._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCreateTime(int p0) {}

    public void setCreateTimeIsSet(boolean p0) {}

    public void setFieldValue(Role._Fields p0, Object p1) {}

    public void setOwnerName(String p0) {}

    public void setOwnerNameIsSet(boolean p0) {}

    public void setRoleName(String p0) {}

    public void setRoleNameIsSet(boolean p0) {}

    public void unsetCreateTime() {}

    public void unsetOwnerName() {}

    public void unsetRoleName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CREATE_TIME, OWNER_NAME, ROLE_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Role._Fields findByName(String p0) {
            return null;
        }

        public static Role._Fields findByThriftId(int p0) {
            return null;
        }

        public static Role._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
