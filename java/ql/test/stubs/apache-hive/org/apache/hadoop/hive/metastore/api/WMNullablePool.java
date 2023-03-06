// Generated automatically from org.apache.hadoop.hive.metastore.api.WMNullablePool for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMNullablePool implements Cloneable, Comparable<WMNullablePool>, Serializable,
        TBase<WMNullablePool, WMNullablePool._Fields> {
    public Object getFieldValue(WMNullablePool._Fields p0) {
        return null;
    }

    public String getPoolPath() {
        return null;
    }

    public String getResourcePlanName() {
        return null;
    }

    public String getSchedulingPolicy() {
        return null;
    }

    public String toString() {
        return null;
    }

    public WMNullablePool deepCopy() {
        return null;
    }

    public WMNullablePool() {}

    public WMNullablePool(String p0, String p1) {}

    public WMNullablePool(WMNullablePool p0) {}

    public WMNullablePool._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMNullablePool p0) {
        return false;
    }

    public boolean isIsSetSchedulingPolicy() {
        return false;
    }

    public boolean isSet(WMNullablePool._Fields p0) {
        return false;
    }

    public boolean isSetAllocFraction() {
        return false;
    }

    public boolean isSetIsSetSchedulingPolicy() {
        return false;
    }

    public boolean isSetPoolPath() {
        return false;
    }

    public boolean isSetQueryParallelism() {
        return false;
    }

    public boolean isSetResourcePlanName() {
        return false;
    }

    public boolean isSetSchedulingPolicy() {
        return false;
    }

    public double getAllocFraction() {
        return 0;
    }

    public int compareTo(WMNullablePool p0) {
        return 0;
    }

    public int getQueryParallelism() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMNullablePool._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setAllocFraction(double p0) {}

    public void setAllocFractionIsSet(boolean p0) {}

    public void setFieldValue(WMNullablePool._Fields p0, Object p1) {}

    public void setIsSetSchedulingPolicy(boolean p0) {}

    public void setIsSetSchedulingPolicyIsSet(boolean p0) {}

    public void setPoolPath(String p0) {}

    public void setPoolPathIsSet(boolean p0) {}

    public void setQueryParallelism(int p0) {}

    public void setQueryParallelismIsSet(boolean p0) {}

    public void setResourcePlanName(String p0) {}

    public void setResourcePlanNameIsSet(boolean p0) {}

    public void setSchedulingPolicy(String p0) {}

    public void setSchedulingPolicyIsSet(boolean p0) {}

    public void unsetAllocFraction() {}

    public void unsetIsSetSchedulingPolicy() {}

    public void unsetPoolPath() {}

    public void unsetQueryParallelism() {}

    public void unsetResourcePlanName() {}

    public void unsetSchedulingPolicy() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        ALLOC_FRACTION, IS_SET_SCHEDULING_POLICY, POOL_PATH, QUERY_PARALLELISM, RESOURCE_PLAN_NAME, SCHEDULING_POLICY;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMNullablePool._Fields findByName(String p0) {
            return null;
        }

        public static WMNullablePool._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMNullablePool._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
