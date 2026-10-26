// Generated automatically from org.apache.hadoop.hive.metastore.api.BinaryColumnStatsData for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class BinaryColumnStatsData implements Cloneable, Comparable<BinaryColumnStatsData>,
        Serializable, TBase<BinaryColumnStatsData, BinaryColumnStatsData._Fields> {
    public BinaryColumnStatsData deepCopy() {
        return null;
    }

    public BinaryColumnStatsData() {}

    public BinaryColumnStatsData(BinaryColumnStatsData p0) {}

    public BinaryColumnStatsData(long p0, double p1, long p2) {}

    public BinaryColumnStatsData._Fields fieldForId(int p0) {
        return null;
    }

    public ByteBuffer bufferForBitVectors() {
        return null;
    }

    public Object getFieldValue(BinaryColumnStatsData._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(BinaryColumnStatsData p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(BinaryColumnStatsData._Fields p0) {
        return false;
    }

    public boolean isSetAvgColLen() {
        return false;
    }

    public boolean isSetBitVectors() {
        return false;
    }

    public boolean isSetMaxColLen() {
        return false;
    }

    public boolean isSetNumNulls() {
        return false;
    }

    public byte[] getBitVectors() {
        return null;
    }

    public double getAvgColLen() {
        return 0;
    }

    public int compareTo(BinaryColumnStatsData p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getMaxColLen() {
        return 0;
    }

    public long getNumNulls() {
        return 0;
    }

    public static java.util.Map<BinaryColumnStatsData._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setAvgColLen(double p0) {}

    public void setAvgColLenIsSet(boolean p0) {}

    public void setBitVectors(ByteBuffer p0) {}

    public void setBitVectors(byte[] p0) {}

    public void setBitVectorsIsSet(boolean p0) {}

    public void setFieldValue(BinaryColumnStatsData._Fields p0, Object p1) {}

    public void setMaxColLen(long p0) {}

    public void setMaxColLenIsSet(boolean p0) {}

    public void setNumNulls(long p0) {}

    public void setNumNullsIsSet(boolean p0) {}

    public void unsetAvgColLen() {}

    public void unsetBitVectors() {}

    public void unsetMaxColLen() {}

    public void unsetNumNulls() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        AVG_COL_LEN, BIT_VECTORS, MAX_COL_LEN, NUM_NULLS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static BinaryColumnStatsData._Fields findByName(String p0) {
            return null;
        }

        public static BinaryColumnStatsData._Fields findByThriftId(int p0) {
            return null;
        }

        public static BinaryColumnStatsData._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
