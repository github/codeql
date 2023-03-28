// Generated automatically from org.apache.hadoop.hive.metastore.api.PrincipalPrivilegeSet for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PrivilegeGrantInfo;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PrincipalPrivilegeSet implements Cloneable, Comparable<PrincipalPrivilegeSet>,
        Serializable, TBase<PrincipalPrivilegeSet, PrincipalPrivilegeSet._Fields> {
    public Map<String, List<PrivilegeGrantInfo>> getGroupPrivileges() {
        return null;
    }

    public Map<String, List<PrivilegeGrantInfo>> getRolePrivileges() {
        return null;
    }

    public Map<String, List<PrivilegeGrantInfo>> getUserPrivileges() {
        return null;
    }

    public Object getFieldValue(PrincipalPrivilegeSet._Fields p0) {
        return null;
    }

    public PrincipalPrivilegeSet deepCopy() {
        return null;
    }

    public PrincipalPrivilegeSet() {}

    public PrincipalPrivilegeSet(Map<String, List<PrivilegeGrantInfo>> p0,
            Map<String, List<PrivilegeGrantInfo>> p1, Map<String, List<PrivilegeGrantInfo>> p2) {}

    public PrincipalPrivilegeSet(PrincipalPrivilegeSet p0) {}

    public PrincipalPrivilegeSet._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PrincipalPrivilegeSet p0) {
        return false;
    }

    public boolean isSet(PrincipalPrivilegeSet._Fields p0) {
        return false;
    }

    public boolean isSetGroupPrivileges() {
        return false;
    }

    public boolean isSetRolePrivileges() {
        return false;
    }

    public boolean isSetUserPrivileges() {
        return false;
    }

    public int compareTo(PrincipalPrivilegeSet p0) {
        return 0;
    }

    public int getGroupPrivilegesSize() {
        return 0;
    }

    public int getRolePrivilegesSize() {
        return 0;
    }

    public int getUserPrivilegesSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PrincipalPrivilegeSet._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void putToGroupPrivileges(String p0, List<PrivilegeGrantInfo> p1) {}

    public void putToRolePrivileges(String p0, List<PrivilegeGrantInfo> p1) {}

    public void putToUserPrivileges(String p0, List<PrivilegeGrantInfo> p1) {}

    public void read(TProtocol p0) {}

    public void setFieldValue(PrincipalPrivilegeSet._Fields p0, Object p1) {}

    public void setGroupPrivileges(Map<String, List<PrivilegeGrantInfo>> p0) {}

    public void setGroupPrivilegesIsSet(boolean p0) {}

    public void setRolePrivileges(Map<String, List<PrivilegeGrantInfo>> p0) {}

    public void setRolePrivilegesIsSet(boolean p0) {}

    public void setUserPrivileges(Map<String, List<PrivilegeGrantInfo>> p0) {}

    public void setUserPrivilegesIsSet(boolean p0) {}

    public void unsetGroupPrivileges() {}

    public void unsetRolePrivileges() {}

    public void unsetUserPrivileges() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        GROUP_PRIVILEGES, ROLE_PRIVILEGES, USER_PRIVILEGES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PrincipalPrivilegeSet._Fields findByName(String p0) {
            return null;
        }

        public static PrincipalPrivilegeSet._Fields findByThriftId(int p0) {
            return null;
        }

        public static PrincipalPrivilegeSet._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
