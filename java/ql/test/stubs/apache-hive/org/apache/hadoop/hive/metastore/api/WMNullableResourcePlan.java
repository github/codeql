// Generated automatically from org.apache.hadoop.hive.metastore.api.WMNullableResourcePlan for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.WMResourcePlanStatus;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMNullableResourcePlan implements Cloneable, Comparable<WMNullableResourcePlan>,
        Serializable, TBase<WMNullableResourcePlan, WMNullableResourcePlan._Fields> {
    public Object getFieldValue(WMNullableResourcePlan._Fields p0) {
        return null;
    }

    public String getDefaultPoolPath() {
        return null;
    }

    public String getName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public WMNullableResourcePlan deepCopy() {
        return null;
    }

    public WMNullableResourcePlan() {}

    public WMNullableResourcePlan(WMNullableResourcePlan p0) {}

    public WMNullableResourcePlan._Fields fieldForId(int p0) {
        return null;
    }

    public WMResourcePlanStatus getStatus() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMNullableResourcePlan p0) {
        return false;
    }

    public boolean isIsSetDefaultPoolPath() {
        return false;
    }

    public boolean isIsSetQueryParallelism() {
        return false;
    }

    public boolean isSet(WMNullableResourcePlan._Fields p0) {
        return false;
    }

    public boolean isSetDefaultPoolPath() {
        return false;
    }

    public boolean isSetIsSetDefaultPoolPath() {
        return false;
    }

    public boolean isSetIsSetQueryParallelism() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public boolean isSetQueryParallelism() {
        return false;
    }

    public boolean isSetStatus() {
        return false;
    }

    public int compareTo(WMNullableResourcePlan p0) {
        return 0;
    }

    public int getQueryParallelism() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMNullableResourcePlan._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setDefaultPoolPath(String p0) {}

    public void setDefaultPoolPathIsSet(boolean p0) {}

    public void setFieldValue(WMNullableResourcePlan._Fields p0, Object p1) {}

    public void setIsSetDefaultPoolPath(boolean p0) {}

    public void setIsSetDefaultPoolPathIsSet(boolean p0) {}

    public void setIsSetQueryParallelism(boolean p0) {}

    public void setIsSetQueryParallelismIsSet(boolean p0) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void setQueryParallelism(int p0) {}

    public void setQueryParallelismIsSet(boolean p0) {}

    public void setStatus(WMResourcePlanStatus p0) {}

    public void setStatusIsSet(boolean p0) {}

    public void unsetDefaultPoolPath() {}

    public void unsetIsSetDefaultPoolPath() {}

    public void unsetIsSetQueryParallelism() {}

    public void unsetName() {}

    public void unsetQueryParallelism() {}

    public void unsetStatus() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        DEFAULT_POOL_PATH, IS_SET_DEFAULT_POOL_PATH, IS_SET_QUERY_PARALLELISM, NAME, QUERY_PARALLELISM, STATUS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMNullableResourcePlan._Fields findByName(String p0) {
            return null;
        }

        public static WMNullableResourcePlan._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMNullableResourcePlan._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
