// Generated automatically from org.apache.hadoop.hive.metastore.api.WMPool for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMPool
        implements Cloneable, Comparable<WMPool>, Serializable, TBase<WMPool, WMPool._Fields> {
    public Object getFieldValue(WMPool._Fields p0) {
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

    public WMPool deepCopy() {
        return null;
    }

    public WMPool() {}

    public WMPool(String p0, String p1) {}

    public WMPool(WMPool p0) {}

    public WMPool._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMPool p0) {
        return false;
    }

    public boolean isSet(WMPool._Fields p0) {
        return false;
    }

    public boolean isSetAllocFraction() {
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

    public int compareTo(WMPool p0) {
        return 0;
    }

    public int getQueryParallelism() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMPool._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setAllocFraction(double p0) {}

    public void setAllocFractionIsSet(boolean p0) {}

    public void setFieldValue(WMPool._Fields p0, Object p1) {}

    public void setPoolPath(String p0) {}

    public void setPoolPathIsSet(boolean p0) {}

    public void setQueryParallelism(int p0) {}

    public void setQueryParallelismIsSet(boolean p0) {}

    public void setResourcePlanName(String p0) {}

    public void setResourcePlanNameIsSet(boolean p0) {}

    public void setSchedulingPolicy(String p0) {}

    public void setSchedulingPolicyIsSet(boolean p0) {}

    public void unsetAllocFraction() {}

    public void unsetPoolPath() {}

    public void unsetQueryParallelism() {}

    public void unsetResourcePlanName() {}

    public void unsetSchedulingPolicy() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        ALLOC_FRACTION, POOL_PATH, QUERY_PARALLELISM, RESOURCE_PLAN_NAME, SCHEDULING_POLICY;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMPool._Fields findByName(String p0) {
            return null;
        }

        public static WMPool._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMPool._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
