// Generated automatically from org.apache.hadoop.hive.metastore.api.Decimal for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Decimal
        implements Cloneable, Comparable<Decimal>, Serializable, TBase<Decimal, Decimal._Fields> {
    public ByteBuffer bufferForUnscaled() {
        return null;
    }

    public Decimal deepCopy() {
        return null;
    }

    public Decimal() {}

    public Decimal(Decimal p0) {}

    public Decimal(short p0, ByteBuffer p1) {}

    public Decimal._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(Decimal._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Decimal p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(Decimal._Fields p0) {
        return false;
    }

    public boolean isSetScale() {
        return false;
    }

    public boolean isSetUnscaled() {
        return false;
    }

    public byte[] getUnscaled() {
        return null;
    }

    public int compareTo(Decimal p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public short getScale() {
        return 0;
    }

    public static java.util.Map<Decimal._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(Decimal._Fields p0, Object p1) {}

    public void setScale(short p0) {}

    public void setScaleIsSet(boolean p0) {}

    public void setUnscaled(ByteBuffer p0) {}

    public void setUnscaled(byte[] p0) {}

    public void setUnscaledIsSet(boolean p0) {}

    public void unsetScale() {}

    public void unsetUnscaled() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        SCALE, UNSCALED;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Decimal._Fields findByName(String p0) {
            return null;
        }

        public static Decimal._Fields findByThriftId(int p0) {
            return null;
        }

        public static Decimal._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
