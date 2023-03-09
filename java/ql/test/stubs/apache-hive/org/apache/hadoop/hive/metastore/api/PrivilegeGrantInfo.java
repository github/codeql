// Generated automatically from org.apache.hadoop.hive.metastore.api.PrivilegeGrantInfo for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PrincipalType;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PrivilegeGrantInfo implements Cloneable, Comparable<PrivilegeGrantInfo>, Serializable,
        TBase<PrivilegeGrantInfo, PrivilegeGrantInfo._Fields> {
    public Object getFieldValue(PrivilegeGrantInfo._Fields p0) {
        return null;
    }

    public PrincipalType getGrantorType() {
        return null;
    }

    public PrivilegeGrantInfo deepCopy() {
        return null;
    }

    public PrivilegeGrantInfo() {}

    public PrivilegeGrantInfo(PrivilegeGrantInfo p0) {}

    public PrivilegeGrantInfo(String p0, int p1, String p2, PrincipalType p3, boolean p4) {}

    public PrivilegeGrantInfo._Fields fieldForId(int p0) {
        return null;
    }

    public String getGrantor() {
        return null;
    }

    public String getPrivilege() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PrivilegeGrantInfo p0) {
        return false;
    }

    public boolean isGrantOption() {
        return false;
    }

    public boolean isSet(PrivilegeGrantInfo._Fields p0) {
        return false;
    }

    public boolean isSetCreateTime() {
        return false;
    }

    public boolean isSetGrantOption() {
        return false;
    }

    public boolean isSetGrantor() {
        return false;
    }

    public boolean isSetGrantorType() {
        return false;
    }

    public boolean isSetPrivilege() {
        return false;
    }

    public int compareTo(PrivilegeGrantInfo p0) {
        return 0;
    }

    public int getCreateTime() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PrivilegeGrantInfo._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCreateTime(int p0) {}

    public void setCreateTimeIsSet(boolean p0) {}

    public void setFieldValue(PrivilegeGrantInfo._Fields p0, Object p1) {}

    public void setGrantOption(boolean p0) {}

    public void setGrantOptionIsSet(boolean p0) {}

    public void setGrantor(String p0) {}

    public void setGrantorIsSet(boolean p0) {}

    public void setGrantorType(PrincipalType p0) {}

    public void setGrantorTypeIsSet(boolean p0) {}

    public void setPrivilege(String p0) {}

    public void setPrivilegeIsSet(boolean p0) {}

    public void unsetCreateTime() {}

    public void unsetGrantOption() {}

    public void unsetGrantor() {}

    public void unsetGrantorType() {}

    public void unsetPrivilege() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CREATE_TIME, GRANTOR, GRANTOR_TYPE, GRANT_OPTION, PRIVILEGE;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PrivilegeGrantInfo._Fields findByName(String p0) {
            return null;
        }

        public static PrivilegeGrantInfo._Fields findByThriftId(int p0) {
            return null;
        }

        public static PrivilegeGrantInfo._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
