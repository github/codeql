// Generated automatically from org.apache.hadoop.hive.metastore.api.WMFullResourcePlan for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.WMMapping;
import org.apache.hadoop.hive.metastore.api.WMPool;
import org.apache.hadoop.hive.metastore.api.WMPoolTrigger;
import org.apache.hadoop.hive.metastore.api.WMResourcePlan;
import org.apache.hadoop.hive.metastore.api.WMTrigger;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMFullResourcePlan implements Cloneable, Comparable<WMFullResourcePlan>, Serializable,
        TBase<WMFullResourcePlan, WMFullResourcePlan._Fields> {
    public Iterator<WMMapping> getMappingsIterator() {
        return null;
    }

    public Iterator<WMPool> getPoolsIterator() {
        return null;
    }

    public Iterator<WMPoolTrigger> getPoolTriggersIterator() {
        return null;
    }

    public Iterator<WMTrigger> getTriggersIterator() {
        return null;
    }

    public List<WMMapping> getMappings() {
        return null;
    }

    public List<WMPool> getPools() {
        return null;
    }

    public List<WMPoolTrigger> getPoolTriggers() {
        return null;
    }

    public List<WMTrigger> getTriggers() {
        return null;
    }

    public Object getFieldValue(WMFullResourcePlan._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public WMFullResourcePlan deepCopy() {
        return null;
    }

    public WMFullResourcePlan() {}

    public WMFullResourcePlan(WMFullResourcePlan p0) {}

    public WMFullResourcePlan(WMResourcePlan p0, List<WMPool> p1) {}

    public WMFullResourcePlan._Fields fieldForId(int p0) {
        return null;
    }

    public WMResourcePlan getPlan() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMFullResourcePlan p0) {
        return false;
    }

    public boolean isSet(WMFullResourcePlan._Fields p0) {
        return false;
    }

    public boolean isSetMappings() {
        return false;
    }

    public boolean isSetPlan() {
        return false;
    }

    public boolean isSetPoolTriggers() {
        return false;
    }

    public boolean isSetPools() {
        return false;
    }

    public boolean isSetTriggers() {
        return false;
    }

    public int compareTo(WMFullResourcePlan p0) {
        return 0;
    }

    public int getMappingsSize() {
        return 0;
    }

    public int getPoolTriggersSize() {
        return 0;
    }

    public int getPoolsSize() {
        return 0;
    }

    public int getTriggersSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMFullResourcePlan._Fields, FieldMetaData> metaDataMap = null;

    public void addToMappings(WMMapping p0) {}

    public void addToPoolTriggers(WMPoolTrigger p0) {}

    public void addToPools(WMPool p0) {}

    public void addToTriggers(WMTrigger p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(WMFullResourcePlan._Fields p0, Object p1) {}

    public void setMappings(List<WMMapping> p0) {}

    public void setMappingsIsSet(boolean p0) {}

    public void setPlan(WMResourcePlan p0) {}

    public void setPlanIsSet(boolean p0) {}

    public void setPoolTriggers(List<WMPoolTrigger> p0) {}

    public void setPoolTriggersIsSet(boolean p0) {}

    public void setPools(List<WMPool> p0) {}

    public void setPoolsIsSet(boolean p0) {}

    public void setTriggers(List<WMTrigger> p0) {}

    public void setTriggersIsSet(boolean p0) {}

    public void unsetMappings() {}

    public void unsetPlan() {}

    public void unsetPoolTriggers() {}

    public void unsetPools() {}

    public void unsetTriggers() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        MAPPINGS, PLAN, POOLS, POOL_TRIGGERS, TRIGGERS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMFullResourcePlan._Fields findByName(String p0) {
            return null;
        }

        public static WMFullResourcePlan._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMFullResourcePlan._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
