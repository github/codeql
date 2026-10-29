// Generated automatically from org.apache.hadoop.hive.metastore.api.WMTrigger for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMTrigger implements Cloneable, Comparable<WMTrigger>, Serializable,
        TBase<WMTrigger, WMTrigger._Fields> {
    public Object getFieldValue(WMTrigger._Fields p0) {
        return null;
    }

    public String getActionExpression() {
        return null;
    }

    public String getResourcePlanName() {
        return null;
    }

    public String getTriggerExpression() {
        return null;
    }

    public String getTriggerName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public WMTrigger deepCopy() {
        return null;
    }

    public WMTrigger() {}

    public WMTrigger(String p0, String p1) {}

    public WMTrigger(WMTrigger p0) {}

    public WMTrigger._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMTrigger p0) {
        return false;
    }

    public boolean isIsInUnmanaged() {
        return false;
    }

    public boolean isSet(WMTrigger._Fields p0) {
        return false;
    }

    public boolean isSetActionExpression() {
        return false;
    }

    public boolean isSetIsInUnmanaged() {
        return false;
    }

    public boolean isSetResourcePlanName() {
        return false;
    }

    public boolean isSetTriggerExpression() {
        return false;
    }

    public boolean isSetTriggerName() {
        return false;
    }

    public int compareTo(WMTrigger p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMTrigger._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setActionExpression(String p0) {}

    public void setActionExpressionIsSet(boolean p0) {}

    public void setFieldValue(WMTrigger._Fields p0, Object p1) {}

    public void setIsInUnmanaged(boolean p0) {}

    public void setIsInUnmanagedIsSet(boolean p0) {}

    public void setResourcePlanName(String p0) {}

    public void setResourcePlanNameIsSet(boolean p0) {}

    public void setTriggerExpression(String p0) {}

    public void setTriggerExpressionIsSet(boolean p0) {}

    public void setTriggerName(String p0) {}

    public void setTriggerNameIsSet(boolean p0) {}

    public void unsetActionExpression() {}

    public void unsetIsInUnmanaged() {}

    public void unsetResourcePlanName() {}

    public void unsetTriggerExpression() {}

    public void unsetTriggerName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        ACTION_EXPRESSION, IS_IN_UNMANAGED, RESOURCE_PLAN_NAME, TRIGGER_EXPRESSION, TRIGGER_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMTrigger._Fields findByName(String p0) {
            return null;
        }

        public static WMTrigger._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMTrigger._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
