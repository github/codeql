// Generated automatically from org.apache.hadoop.hive.metastore.api.ResourceUri for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.ResourceType;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class ResourceUri implements Cloneable, Comparable<ResourceUri>, Serializable,
        TBase<ResourceUri, ResourceUri._Fields> {
    public Object getFieldValue(ResourceUri._Fields p0) {
        return null;
    }

    public ResourceType getResourceType() {
        return null;
    }

    public ResourceUri deepCopy() {
        return null;
    }

    public ResourceUri() {}

    public ResourceUri(ResourceType p0, String p1) {}

    public ResourceUri(ResourceUri p0) {}

    public ResourceUri._Fields fieldForId(int p0) {
        return null;
    }

    public String getUri() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(ResourceUri p0) {
        return false;
    }

    public boolean isSet(ResourceUri._Fields p0) {
        return false;
    }

    public boolean isSetResourceType() {
        return false;
    }

    public boolean isSetUri() {
        return false;
    }

    public int compareTo(ResourceUri p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<ResourceUri._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(ResourceUri._Fields p0, Object p1) {}

    public void setResourceType(ResourceType p0) {}

    public void setResourceTypeIsSet(boolean p0) {}

    public void setUri(String p0) {}

    public void setUriIsSet(boolean p0) {}

    public void unsetResourceType() {}

    public void unsetUri() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        RESOURCE_TYPE, URI;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static ResourceUri._Fields findByName(String p0) {
            return null;
        }

        public static ResourceUri._Fields findByThriftId(int p0) {
            return null;
        }

        public static ResourceUri._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
