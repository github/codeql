// Generated automatically from org.apache.hadoop.hive.metastore.api.RuntimeStat for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class RuntimeStat implements Cloneable, Comparable<RuntimeStat>, Serializable,
        TBase<RuntimeStat, RuntimeStat._Fields> {
    public ByteBuffer bufferForPayload() {
        return null;
    }

    public Object getFieldValue(RuntimeStat._Fields p0) {
        return null;
    }

    public RuntimeStat deepCopy() {
        return null;
    }

    public RuntimeStat() {}

    public RuntimeStat(RuntimeStat p0) {}

    public RuntimeStat(int p0, ByteBuffer p1) {}

    public RuntimeStat._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(RuntimeStat p0) {
        return false;
    }

    public boolean isSet(RuntimeStat._Fields p0) {
        return false;
    }

    public boolean isSetCreateTime() {
        return false;
    }

    public boolean isSetPayload() {
        return false;
    }

    public boolean isSetWeight() {
        return false;
    }

    public byte[] getPayload() {
        return null;
    }

    public int compareTo(RuntimeStat p0) {
        return 0;
    }

    public int getCreateTime() {
        return 0;
    }

    public int getWeight() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<RuntimeStat._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCreateTime(int p0) {}

    public void setCreateTimeIsSet(boolean p0) {}

    public void setFieldValue(RuntimeStat._Fields p0, Object p1) {}

    public void setPayload(ByteBuffer p0) {}

    public void setPayload(byte[] p0) {}

    public void setPayloadIsSet(boolean p0) {}

    public void setWeight(int p0) {}

    public void setWeightIsSet(boolean p0) {}

    public void unsetCreateTime() {}

    public void unsetPayload() {}

    public void unsetWeight() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CREATE_TIME, PAYLOAD, WEIGHT;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static RuntimeStat._Fields findByName(String p0) {
            return null;
        }

        public static RuntimeStat._Fields findByThriftId(int p0) {
            return null;
        }

        public static RuntimeStat._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
