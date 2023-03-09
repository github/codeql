// Generated automatically from org.apache.hadoop.hive.metastore.api.WMMapping for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMMapping implements Cloneable, Comparable<WMMapping>, Serializable,
        TBase<WMMapping, WMMapping._Fields> {
    public Object getFieldValue(WMMapping._Fields p0) {
        return null;
    }

    public String getEntityName() {
        return null;
    }

    public String getEntityType() {
        return null;
    }

    public String getPoolPath() {
        return null;
    }

    public String getResourcePlanName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public WMMapping deepCopy() {
        return null;
    }

    public WMMapping() {}

    public WMMapping(String p0, String p1, String p2) {}

    public WMMapping(WMMapping p0) {}

    public WMMapping._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMMapping p0) {
        return false;
    }

    public boolean isSet(WMMapping._Fields p0) {
        return false;
    }

    public boolean isSetEntityName() {
        return false;
    }

    public boolean isSetEntityType() {
        return false;
    }

    public boolean isSetOrdering() {
        return false;
    }

    public boolean isSetPoolPath() {
        return false;
    }

    public boolean isSetResourcePlanName() {
        return false;
    }

    public int compareTo(WMMapping p0) {
        return 0;
    }

    public int getOrdering() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMMapping._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setEntityName(String p0) {}

    public void setEntityNameIsSet(boolean p0) {}

    public void setEntityType(String p0) {}

    public void setEntityTypeIsSet(boolean p0) {}

    public void setFieldValue(WMMapping._Fields p0, Object p1) {}

    public void setOrdering(int p0) {}

    public void setOrderingIsSet(boolean p0) {}

    public void setPoolPath(String p0) {}

    public void setPoolPathIsSet(boolean p0) {}

    public void setResourcePlanName(String p0) {}

    public void setResourcePlanNameIsSet(boolean p0) {}

    public void unsetEntityName() {}

    public void unsetEntityType() {}

    public void unsetOrdering() {}

    public void unsetPoolPath() {}

    public void unsetResourcePlanName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        ENTITY_NAME, ENTITY_TYPE, ORDERING, POOL_PATH, RESOURCE_PLAN_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMMapping._Fields findByName(String p0) {
            return null;
        }

        public static WMMapping._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMMapping._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
