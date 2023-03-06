// Generated automatically from org.apache.hadoop.hive.metastore.api.EnvironmentContext for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class EnvironmentContext implements Cloneable, Comparable<EnvironmentContext>, Serializable,
        TBase<EnvironmentContext, EnvironmentContext._Fields> {
    public EnvironmentContext deepCopy() {
        return null;
    }

    public EnvironmentContext() {}

    public EnvironmentContext(EnvironmentContext p0) {}

    public EnvironmentContext(Map<String, String> p0) {}

    public EnvironmentContext._Fields fieldForId(int p0) {
        return null;
    }

    public Map<String, String> getProperties() {
        return null;
    }

    public Object getFieldValue(EnvironmentContext._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(EnvironmentContext p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(EnvironmentContext._Fields p0) {
        return false;
    }

    public boolean isSetProperties() {
        return false;
    }

    public int compareTo(EnvironmentContext p0) {
        return 0;
    }

    public int getPropertiesSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<EnvironmentContext._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void putToProperties(String p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setFieldValue(EnvironmentContext._Fields p0, Object p1) {}

    public void setProperties(Map<String, String> p0) {}

    public void setPropertiesIsSet(boolean p0) {}

    public void unsetProperties() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        PROPERTIES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static EnvironmentContext._Fields findByName(String p0) {
            return null;
        }

        public static EnvironmentContext._Fields findByThriftId(int p0) {
            return null;
        }

        public static EnvironmentContext._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
