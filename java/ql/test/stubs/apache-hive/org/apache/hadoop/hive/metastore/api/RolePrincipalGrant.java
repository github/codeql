// Generated automatically from org.apache.hadoop.hive.metastore.api.RolePrincipalGrant for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PrincipalType;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class RolePrincipalGrant implements Cloneable, Comparable<RolePrincipalGrant>, Serializable,
        TBase<RolePrincipalGrant, RolePrincipalGrant._Fields> {
    public Object getFieldValue(RolePrincipalGrant._Fields p0) {
        return null;
    }

    public PrincipalType getGrantorPrincipalType() {
        return null;
    }

    public PrincipalType getPrincipalType() {
        return null;
    }

    public RolePrincipalGrant deepCopy() {
        return null;
    }

    public RolePrincipalGrant() {}

    public RolePrincipalGrant(RolePrincipalGrant p0) {}

    public RolePrincipalGrant(String p0, String p1, PrincipalType p2, boolean p3, int p4, String p5,
            PrincipalType p6) {}

    public RolePrincipalGrant._Fields fieldForId(int p0) {
        return null;
    }

    public String getGrantorName() {
        return null;
    }

    public String getPrincipalName() {
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

    public boolean equals(RolePrincipalGrant p0) {
        return false;
    }

    public boolean isGrantOption() {
        return false;
    }

    public boolean isSet(RolePrincipalGrant._Fields p0) {
        return false;
    }

    public boolean isSetGrantOption() {
        return false;
    }

    public boolean isSetGrantTime() {
        return false;
    }

    public boolean isSetGrantorName() {
        return false;
    }

    public boolean isSetGrantorPrincipalType() {
        return false;
    }

    public boolean isSetPrincipalName() {
        return false;
    }

    public boolean isSetPrincipalType() {
        return false;
    }

    public boolean isSetRoleName() {
        return false;
    }

    public int compareTo(RolePrincipalGrant p0) {
        return 0;
    }

    public int getGrantTime() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<RolePrincipalGrant._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(RolePrincipalGrant._Fields p0, Object p1) {}

    public void setGrantOption(boolean p0) {}

    public void setGrantOptionIsSet(boolean p0) {}

    public void setGrantTime(int p0) {}

    public void setGrantTimeIsSet(boolean p0) {}

    public void setGrantorName(String p0) {}

    public void setGrantorNameIsSet(boolean p0) {}

    public void setGrantorPrincipalType(PrincipalType p0) {}

    public void setGrantorPrincipalTypeIsSet(boolean p0) {}

    public void setPrincipalName(String p0) {}

    public void setPrincipalNameIsSet(boolean p0) {}

    public void setPrincipalType(PrincipalType p0) {}

    public void setPrincipalTypeIsSet(boolean p0) {}

    public void setRoleName(String p0) {}

    public void setRoleNameIsSet(boolean p0) {}

    public void unsetGrantOption() {}

    public void unsetGrantTime() {}

    public void unsetGrantorName() {}

    public void unsetGrantorPrincipalType() {}

    public void unsetPrincipalName() {}

    public void unsetPrincipalType() {}

    public void unsetRoleName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        GRANTOR_NAME, GRANTOR_PRINCIPAL_TYPE, GRANT_OPTION, GRANT_TIME, PRINCIPAL_NAME, PRINCIPAL_TYPE, ROLE_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static RolePrincipalGrant._Fields findByName(String p0) {
            return null;
        }

        public static RolePrincipalGrant._Fields findByThriftId(int p0) {
            return null;
        }

        public static RolePrincipalGrant._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
