// Generated automatically from org.apache.hadoop.hive.metastore.api.NotificationEventsCountResponse
// for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class NotificationEventsCountResponse
        implements Cloneable, Comparable<NotificationEventsCountResponse>, Serializable,
        TBase<NotificationEventsCountResponse, NotificationEventsCountResponse._Fields> {
    public NotificationEventsCountResponse deepCopy() {
        return null;
    }

    public NotificationEventsCountResponse() {}

    public NotificationEventsCountResponse(NotificationEventsCountResponse p0) {}

    public NotificationEventsCountResponse(long p0) {}

    public NotificationEventsCountResponse._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(NotificationEventsCountResponse._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(NotificationEventsCountResponse p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(NotificationEventsCountResponse._Fields p0) {
        return false;
    }

    public boolean isSetEventsCount() {
        return false;
    }

    public int compareTo(NotificationEventsCountResponse p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getEventsCount() {
        return 0;
    }

    public static java.util.Map<NotificationEventsCountResponse._Fields, FieldMetaData> metaDataMap =
            null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setEventsCount(long p0) {}

    public void setEventsCountIsSet(boolean p0) {}

    public void setFieldValue(NotificationEventsCountResponse._Fields p0, Object p1) {}

    public void unsetEventsCount() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        EVENTS_COUNT;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static NotificationEventsCountResponse._Fields findByName(String p0) {
            return null;
        }

        public static NotificationEventsCountResponse._Fields findByThriftId(int p0) {
            return null;
        }

        public static NotificationEventsCountResponse._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
