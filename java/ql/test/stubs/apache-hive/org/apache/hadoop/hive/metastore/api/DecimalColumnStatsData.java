// Generated automatically from org.apache.hadoop.hive.metastore.api.DecimalColumnStatsData for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.Decimal;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class DecimalColumnStatsData implements Cloneable, Comparable<DecimalColumnStatsData>,
        Serializable, TBase<DecimalColumnStatsData, DecimalColumnStatsData._Fields> {
    public ByteBuffer bufferForBitVectors() {
        return null;
    }

    public Decimal getHighValue() {
        return null;
    }

    public Decimal getLowValue() {
        return null;
    }

    public DecimalColumnStatsData deepCopy() {
        return null;
    }

    public DecimalColumnStatsData() {}

    public DecimalColumnStatsData(DecimalColumnStatsData p0) {}

    public DecimalColumnStatsData(long p0, long p1) {}

    public DecimalColumnStatsData._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(DecimalColumnStatsData._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(DecimalColumnStatsData p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(DecimalColumnStatsData._Fields p0) {
        return false;
    }

    public boolean isSetBitVectors() {
        return false;
    }

    public boolean isSetHighValue() {
        return false;
    }

    public boolean isSetLowValue() {
        return false;
    }

    public boolean isSetNumDVs() {
        return false;
    }

    public boolean isSetNumNulls() {
        return false;
    }

    public byte[] getBitVectors() {
        return null;
    }

    public int compareTo(DecimalColumnStatsData p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getNumDVs() {
        return 0;
    }

    public long getNumNulls() {
        return 0;
    }

    public static java.util.Map<DecimalColumnStatsData._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setBitVectors(ByteBuffer p0) {}

    public void setBitVectors(byte[] p0) {}

    public void setBitVectorsIsSet(boolean p0) {}

    public void setFieldValue(DecimalColumnStatsData._Fields p0, Object p1) {}

    public void setHighValue(Decimal p0) {}

    public void setHighValueIsSet(boolean p0) {}

    public void setLowValue(Decimal p0) {}

    public void setLowValueIsSet(boolean p0) {}

    public void setNumDVs(long p0) {}

    public void setNumDVsIsSet(boolean p0) {}

    public void setNumNulls(long p0) {}

    public void setNumNullsIsSet(boolean p0) {}

    public void unsetBitVectors() {}

    public void unsetHighValue() {}

    public void unsetLowValue() {}

    public void unsetNumDVs() {}

    public void unsetNumNulls() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        BIT_VECTORS, HIGH_VALUE, LOW_VALUE, NUM_DVS, NUM_NULLS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static DecimalColumnStatsData._Fields findByName(String p0) {
            return null;
        }

        public static DecimalColumnStatsData._Fields findByThriftId(int p0) {
            return null;
        }

        public static DecimalColumnStatsData._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
