// Generated automatically from org.apache.hadoop.hive.metastore.api.CurrentNotificationEventId for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class CurrentNotificationEventId
        implements Cloneable, Comparable<CurrentNotificationEventId>, Serializable,
        TBase<CurrentNotificationEventId, CurrentNotificationEventId._Fields> {
    public CurrentNotificationEventId deepCopy() {
        return null;
    }

    public CurrentNotificationEventId() {}

    public CurrentNotificationEventId(CurrentNotificationEventId p0) {}

    public CurrentNotificationEventId(long p0) {}

    public CurrentNotificationEventId._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(CurrentNotificationEventId._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(CurrentNotificationEventId p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(CurrentNotificationEventId._Fields p0) {
        return false;
    }

    public boolean isSetEventId() {
        return false;
    }

    public int compareTo(CurrentNotificationEventId p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getEventId() {
        return 0;
    }

    public static java.util.Map<CurrentNotificationEventId._Fields, FieldMetaData> metaDataMap =
            null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setEventId(long p0) {}

    public void setEventIdIsSet(boolean p0) {}

    public void setFieldValue(CurrentNotificationEventId._Fields p0, Object p1) {}

    public void unsetEventId() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        EVENT_ID;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static CurrentNotificationEventId._Fields findByName(String p0) {
            return null;
        }

        public static CurrentNotificationEventId._Fields findByThriftId(int p0) {
            return null;
        }

        public static CurrentNotificationEventId._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
