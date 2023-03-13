// Generated automatically from org.apache.hadoop.hive.metastore.api.ColumnStatisticsData for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.util.Map;
import org.apache.hadoop.hive.metastore.api.BinaryColumnStatsData;
import org.apache.hadoop.hive.metastore.api.BooleanColumnStatsData;
import org.apache.hadoop.hive.metastore.api.DateColumnStatsData;
import org.apache.hadoop.hive.metastore.api.DecimalColumnStatsData;
import org.apache.hadoop.hive.metastore.api.DoubleColumnStatsData;
import org.apache.hadoop.hive.metastore.api.LongColumnStatsData;
import org.apache.hadoop.hive.metastore.api.StringColumnStatsData;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.TUnion;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TField;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.protocol.TStruct;

public class ColumnStatisticsData
        extends TUnion<ColumnStatisticsData, ColumnStatisticsData._Fields> {
    protected ColumnStatisticsData._Fields enumForId(short p0) {
        return null;
    }

    protected Object standardSchemeReadValue(TProtocol p0, TField p1) {
        return null;
    }

    protected Object tupleSchemeReadValue(TProtocol p0, short p1) {
        return null;
    }

    protected TField getFieldDesc(ColumnStatisticsData._Fields p0) {
        return null;
    }

    protected TStruct getStructDesc() {
        return null;
    }

    protected void checkType(ColumnStatisticsData._Fields p0, Object p1) {}

    protected void standardSchemeWriteValue(TProtocol p0) {}

    protected void tupleSchemeWriteValue(TProtocol p0) {}

    public BinaryColumnStatsData getBinaryStats() {
        return null;
    }

    public BooleanColumnStatsData getBooleanStats() {
        return null;
    }

    public ColumnStatisticsData deepCopy() {
        return null;
    }

    public ColumnStatisticsData() {}

    public ColumnStatisticsData(ColumnStatisticsData p0) {}

    public ColumnStatisticsData(ColumnStatisticsData._Fields p0, Object p1) {}

    public ColumnStatisticsData._Fields fieldForId(int p0) {
        return null;
    }

    public DateColumnStatsData getDateStats() {
        return null;
    }

    public DecimalColumnStatsData getDecimalStats() {
        return null;
    }

    public DoubleColumnStatsData getDoubleStats() {
        return null;
    }

    public LongColumnStatsData getLongStats() {
        return null;
    }

    public StringColumnStatsData getStringStats() {
        return null;
    }

    public boolean equals(ColumnStatisticsData p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSetBinaryStats() {
        return false;
    }

    public boolean isSetBooleanStats() {
        return false;
    }

    public boolean isSetDateStats() {
        return false;
    }

    public boolean isSetDecimalStats() {
        return false;
    }

    public boolean isSetDoubleStats() {
        return false;
    }

    public boolean isSetLongStats() {
        return false;
    }

    public boolean isSetStringStats() {
        return false;
    }

    public int compareTo(ColumnStatisticsData p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static ColumnStatisticsData binaryStats(BinaryColumnStatsData p0) {
        return null;
    }

    public static ColumnStatisticsData booleanStats(BooleanColumnStatsData p0) {
        return null;
    }

    public static ColumnStatisticsData dateStats(DateColumnStatsData p0) {
        return null;
    }

    public static ColumnStatisticsData decimalStats(DecimalColumnStatsData p0) {
        return null;
    }

    public static ColumnStatisticsData doubleStats(DoubleColumnStatsData p0) {
        return null;
    }

    public static ColumnStatisticsData longStats(LongColumnStatsData p0) {
        return null;
    }

    public static ColumnStatisticsData stringStats(StringColumnStatsData p0) {
        return null;
    }

    public static java.util.Map<ColumnStatisticsData._Fields, FieldMetaData> metaDataMap = null;

    public void setBinaryStats(BinaryColumnStatsData p0) {}

    public void setBooleanStats(BooleanColumnStatsData p0) {}

    public void setDateStats(DateColumnStatsData p0) {}

    public void setDecimalStats(DecimalColumnStatsData p0) {}

    public void setDoubleStats(DoubleColumnStatsData p0) {}

    public void setLongStats(LongColumnStatsData p0) {}

    public void setStringStats(StringColumnStatsData p0) {}

    static public enum _Fields implements TFieldIdEnum {
        BINARY_STATS, BOOLEAN_STATS, DATE_STATS, DECIMAL_STATS, DOUBLE_STATS, LONG_STATS, STRING_STATS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static ColumnStatisticsData._Fields findByName(String p0) {
            return null;
        }

        public static ColumnStatisticsData._Fields findByThriftId(int p0) {
            return null;
        }

        public static ColumnStatisticsData._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
