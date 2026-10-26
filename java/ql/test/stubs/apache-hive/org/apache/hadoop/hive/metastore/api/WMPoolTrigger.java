// Generated automatically from org.apache.hadoop.hive.metastore.api.WMPoolTrigger for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMPoolTrigger implements Cloneable, Comparable<WMPoolTrigger>, Serializable,
        TBase<WMPoolTrigger, WMPoolTrigger._Fields> {
    public Object getFieldValue(WMPoolTrigger._Fields p0) {
        return null;
    }

    public String getPool() {
        return null;
    }

    public String getTrigger() {
        return null;
    }

    public String toString() {
        return null;
    }

    public WMPoolTrigger deepCopy() {
        return null;
    }

    public WMPoolTrigger() {}

    public WMPoolTrigger(String p0, String p1) {}

    public WMPoolTrigger(WMPoolTrigger p0) {}

    public WMPoolTrigger._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMPoolTrigger p0) {
        return false;
    }

    public boolean isSet(WMPoolTrigger._Fields p0) {
        return false;
    }

    public boolean isSetPool() {
        return false;
    }

    public boolean isSetTrigger() {
        return false;
    }

    public int compareTo(WMPoolTrigger p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMPoolTrigger._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(WMPoolTrigger._Fields p0, Object p1) {}

    public void setPool(String p0) {}

    public void setPoolIsSet(boolean p0) {}

    public void setTrigger(String p0) {}

    public void setTriggerIsSet(boolean p0) {}

    public void unsetPool() {}

    public void unsetTrigger() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        POOL, TRIGGER;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMPoolTrigger._Fields findByName(String p0) {
            return null;
        }

        public static WMPoolTrigger._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMPoolTrigger._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
