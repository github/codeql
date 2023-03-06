// Generated automatically from org.apache.hadoop.hive.metastore.api.BooleanColumnStatsData for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class BooleanColumnStatsData implements Cloneable, Comparable<BooleanColumnStatsData>,
        Serializable, TBase<BooleanColumnStatsData, BooleanColumnStatsData._Fields> {
    public BooleanColumnStatsData deepCopy() {
        return null;
    }

    public BooleanColumnStatsData() {}

    public BooleanColumnStatsData(BooleanColumnStatsData p0) {}

    public BooleanColumnStatsData(long p0, long p1, long p2) {}

    public BooleanColumnStatsData._Fields fieldForId(int p0) {
        return null;
    }

    public ByteBuffer bufferForBitVectors() {
        return null;
    }

    public Object getFieldValue(BooleanColumnStatsData._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(BooleanColumnStatsData p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(BooleanColumnStatsData._Fields p0) {
        return false;
    }

    public boolean isSetBitVectors() {
        return false;
    }

    public boolean isSetNumFalses() {
        return false;
    }

    public boolean isSetNumNulls() {
        return false;
    }

    public boolean isSetNumTrues() {
        return false;
    }

    public byte[] getBitVectors() {
        return null;
    }

    public int compareTo(BooleanColumnStatsData p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getNumFalses() {
        return 0;
    }

    public long getNumNulls() {
        return 0;
    }

    public long getNumTrues() {
        return 0;
    }

    public static java.util.Map<BooleanColumnStatsData._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setBitVectors(ByteBuffer p0) {}

    public void setBitVectors(byte[] p0) {}

    public void setBitVectorsIsSet(boolean p0) {}

    public void setFieldValue(BooleanColumnStatsData._Fields p0, Object p1) {}

    public void setNumFalses(long p0) {}

    public void setNumFalsesIsSet(boolean p0) {}

    public void setNumNulls(long p0) {}

    public void setNumNullsIsSet(boolean p0) {}

    public void setNumTrues(long p0) {}

    public void setNumTruesIsSet(boolean p0) {}

    public void unsetBitVectors() {}

    public void unsetNumFalses() {}

    public void unsetNumNulls() {}

    public void unsetNumTrues() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        BIT_VECTORS, NUM_FALSES, NUM_NULLS, NUM_TRUES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static BooleanColumnStatsData._Fields findByName(String p0) {
            return null;
        }

        public static BooleanColumnStatsData._Fields findByThriftId(int p0) {
            return null;
        }

        public static BooleanColumnStatsData._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
