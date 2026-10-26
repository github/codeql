// Generated automatically from org.apache.hadoop.hive.metastore.api.HiveObjectPrivilege for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.HiveObjectRef;
import org.apache.hadoop.hive.metastore.api.PrincipalType;
import org.apache.hadoop.hive.metastore.api.PrivilegeGrantInfo;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class HiveObjectPrivilege implements Cloneable, Comparable<HiveObjectPrivilege>,
        Serializable, TBase<HiveObjectPrivilege, HiveObjectPrivilege._Fields> {
    public HiveObjectPrivilege deepCopy() {
        return null;
    }

    public HiveObjectPrivilege() {}

    public HiveObjectPrivilege(HiveObjectPrivilege p0) {}

    public HiveObjectPrivilege(HiveObjectRef p0, String p1, PrincipalType p2, PrivilegeGrantInfo p3,
            String p4) {}

    public HiveObjectPrivilege._Fields fieldForId(int p0) {
        return null;
    }

    public HiveObjectRef getHiveObject() {
        return null;
    }

    public Object getFieldValue(HiveObjectPrivilege._Fields p0) {
        return null;
    }

    public PrincipalType getPrincipalType() {
        return null;
    }

    public PrivilegeGrantInfo getGrantInfo() {
        return null;
    }

    public String getAuthorizer() {
        return null;
    }

    public String getPrincipalName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(HiveObjectPrivilege p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(HiveObjectPrivilege._Fields p0) {
        return false;
    }

    public boolean isSetAuthorizer() {
        return false;
    }

    public boolean isSetGrantInfo() {
        return false;
    }

    public boolean isSetHiveObject() {
        return false;
    }

    public boolean isSetPrincipalName() {
        return false;
    }

    public boolean isSetPrincipalType() {
        return false;
    }

    public int compareTo(HiveObjectPrivilege p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<HiveObjectPrivilege._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setAuthorizer(String p0) {}

    public void setAuthorizerIsSet(boolean p0) {}

    public void setFieldValue(HiveObjectPrivilege._Fields p0, Object p1) {}

    public void setGrantInfo(PrivilegeGrantInfo p0) {}

    public void setGrantInfoIsSet(boolean p0) {}

    public void setHiveObject(HiveObjectRef p0) {}

    public void setHiveObjectIsSet(boolean p0) {}

    public void setPrincipalName(String p0) {}

    public void setPrincipalNameIsSet(boolean p0) {}

    public void setPrincipalType(PrincipalType p0) {}

    public void setPrincipalTypeIsSet(boolean p0) {}

    public void unsetAuthorizer() {}

    public void unsetGrantInfo() {}

    public void unsetHiveObject() {}

    public void unsetPrincipalName() {}

    public void unsetPrincipalType() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        AUTHORIZER, GRANT_INFO, HIVE_OBJECT, PRINCIPAL_NAME, PRINCIPAL_TYPE;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static HiveObjectPrivilege._Fields findByName(String p0) {
            return null;
        }

        public static HiveObjectPrivilege._Fields findByThriftId(int p0) {
            return null;
        }

        public static HiveObjectPrivilege._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
