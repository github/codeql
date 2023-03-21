// Generated automatically from org.apache.hadoop.hive.metastore.api.Date for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Date
        implements Cloneable, Serializable, TBase<Date, Date._Fields>, java.lang.Comparable<Date> {
    public Date deepCopy() {
        return null;
    }

    public Date() {}

    public Date(Date p0) {}

    public Date(long p0) {}

    public Date._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(Date._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Date p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(Date._Fields p0) {
        return false;
    }

    public boolean isSetDaysSinceEpoch() {
        return false;
    }

    public int compareTo(Date p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getDaysSinceEpoch() {
        return 0;
    }

    public static java.util.Map<Date._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setDaysSinceEpoch(long p0) {}

    public void setDaysSinceEpochIsSet(boolean p0) {}

    public void setFieldValue(Date._Fields p0, Object p1) {}

    public void unsetDaysSinceEpoch() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        DAYS_SINCE_EPOCH;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Date._Fields findByName(String p0) {
            return null;
        }

        public static Date._Fields findByThriftId(int p0) {
            return null;
        }

        public static Date._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
