// Generated automatically from org.apache.hadoop.hive.metastore.api.PartitionWithoutSD for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PrincipalPrivilegeSet;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PartitionWithoutSD implements Cloneable, Comparable<PartitionWithoutSD>, Serializable,
        TBase<PartitionWithoutSD, PartitionWithoutSD._Fields> {
    public Iterator<String> getValuesIterator() {
        return null;
    }

    public List<String> getValues() {
        return null;
    }

    public Map<String, String> getParameters() {
        return null;
    }

    public Object getFieldValue(PartitionWithoutSD._Fields p0) {
        return null;
    }

    public PartitionWithoutSD deepCopy() {
        return null;
    }

    public PartitionWithoutSD() {}

    public PartitionWithoutSD(List<String> p0, int p1, int p2, String p3, Map<String, String> p4) {}

    public PartitionWithoutSD(PartitionWithoutSD p0) {}

    public PartitionWithoutSD._Fields fieldForId(int p0) {
        return null;
    }

    public PrincipalPrivilegeSet getPrivileges() {
        return null;
    }

    public String getRelativePath() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PartitionWithoutSD p0) {
        return false;
    }

    public boolean isSet(PartitionWithoutSD._Fields p0) {
        return false;
    }

    public boolean isSetCreateTime() {
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

    public boolean isSetRelativePath() {
        return false;
    }

    public boolean isSetValues() {
        return false;
    }

    public int compareTo(PartitionWithoutSD p0) {
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

    public static java.util.Map<PartitionWithoutSD._Fields, FieldMetaData> metaDataMap = null;

    public void addToValues(String p0) {}

    public void clear() {}

    public void putToParameters(String p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setCreateTime(int p0) {}

    public void setCreateTimeIsSet(boolean p0) {}

    public void setFieldValue(PartitionWithoutSD._Fields p0, Object p1) {}

    public void setLastAccessTime(int p0) {}

    public void setLastAccessTimeIsSet(boolean p0) {}

    public void setParameters(Map<String, String> p0) {}

    public void setParametersIsSet(boolean p0) {}

    public void setPrivileges(PrincipalPrivilegeSet p0) {}

    public void setPrivilegesIsSet(boolean p0) {}

    public void setRelativePath(String p0) {}

    public void setRelativePathIsSet(boolean p0) {}

    public void setValues(List<String> p0) {}

    public void setValuesIsSet(boolean p0) {}

    public void unsetCreateTime() {}

    public void unsetLastAccessTime() {}

    public void unsetParameters() {}

    public void unsetPrivileges() {}

    public void unsetRelativePath() {}

    public void unsetValues() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CREATE_TIME, LAST_ACCESS_TIME, PARAMETERS, PRIVILEGES, RELATIVE_PATH, VALUES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PartitionWithoutSD._Fields findByName(String p0) {
            return null;
        }

        public static PartitionWithoutSD._Fields findByThriftId(int p0) {
            return null;
        }

        public static PartitionWithoutSD._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
