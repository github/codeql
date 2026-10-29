// Generated automatically from org.apache.hadoop.hive.metastore.api.Database for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PrincipalPrivilegeSet;
import org.apache.hadoop.hive.metastore.api.PrincipalType;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Database implements Cloneable, Comparable<Database>, Serializable,
        TBase<Database, Database._Fields> {
    public Database deepCopy() {
        return null;
    }

    public Database() {}

    public Database(Database p0) {}

    public Database(String p0, String p1, String p2, Map<String, String> p3) {}

    public Database._Fields fieldForId(int p0) {
        return null;
    }

    public Map<String, String> getParameters() {
        return null;
    }

    public Object getFieldValue(Database._Fields p0) {
        return null;
    }

    public PrincipalPrivilegeSet getPrivileges() {
        return null;
    }

    public PrincipalType getOwnerType() {
        return null;
    }

    public String getCatalogName() {
        return null;
    }

    public String getDescription() {
        return null;
    }

    public String getLocationUri() {
        return null;
    }

    public String getName() {
        return null;
    }

    public String getOwnerName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Database p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(Database._Fields p0) {
        return false;
    }

    public boolean isSetCatalogName() {
        return false;
    }

    public boolean isSetDescription() {
        return false;
    }

    public boolean isSetLocationUri() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public boolean isSetOwnerName() {
        return false;
    }

    public boolean isSetOwnerType() {
        return false;
    }

    public boolean isSetParameters() {
        return false;
    }

    public boolean isSetPrivileges() {
        return false;
    }

    public int compareTo(Database p0) {
        return 0;
    }

    public int getParametersSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Database._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void putToParameters(String p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setCatalogName(String p0) {}

    public void setCatalogNameIsSet(boolean p0) {}

    public void setDescription(String p0) {}

    public void setDescriptionIsSet(boolean p0) {}

    public void setFieldValue(Database._Fields p0, Object p1) {}

    public void setLocationUri(String p0) {}

    public void setLocationUriIsSet(boolean p0) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void setOwnerName(String p0) {}

    public void setOwnerNameIsSet(boolean p0) {}

    public void setOwnerType(PrincipalType p0) {}

    public void setOwnerTypeIsSet(boolean p0) {}

    public void setParameters(Map<String, String> p0) {}

    public void setParametersIsSet(boolean p0) {}

    public void setPrivileges(PrincipalPrivilegeSet p0) {}

    public void setPrivilegesIsSet(boolean p0) {}

    public void unsetCatalogName() {}

    public void unsetDescription() {}

    public void unsetLocationUri() {}

    public void unsetName() {}

    public void unsetOwnerName() {}

    public void unsetOwnerType() {}

    public void unsetParameters() {}

    public void unsetPrivileges() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CATALOG_NAME, DESCRIPTION, LOCATION_URI, NAME, OWNER_NAME, OWNER_TYPE, PARAMETERS, PRIVILEGES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Database._Fields findByName(String p0) {
            return null;
        }

        public static Database._Fields findByThriftId(int p0) {
            return null;
        }

        public static Database._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
