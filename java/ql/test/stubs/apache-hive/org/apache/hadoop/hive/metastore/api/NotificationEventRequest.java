// Generated automatically from org.apache.hadoop.hive.metastore.api.NotificationEventRequest for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class NotificationEventRequest implements Cloneable, Comparable<NotificationEventRequest>,
        Serializable, TBase<NotificationEventRequest, NotificationEventRequest._Fields> {
    public NotificationEventRequest deepCopy() {
        return null;
    }

    public NotificationEventRequest() {}

    public NotificationEventRequest(NotificationEventRequest p0) {}

    public NotificationEventRequest(long p0) {}

    public NotificationEventRequest._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(NotificationEventRequest._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(NotificationEventRequest p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(NotificationEventRequest._Fields p0) {
        return false;
    }

    public boolean isSetLastEvent() {
        return false;
    }

    public boolean isSetMaxEvents() {
        return false;
    }

    public int compareTo(NotificationEventRequest p0) {
        return 0;
    }

    public int getMaxEvents() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getLastEvent() {
        return 0;
    }

    public static java.util.Map<NotificationEventRequest._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(NotificationEventRequest._Fields p0, Object p1) {}

    public void setLastEvent(long p0) {}

    public void setLastEventIsSet(boolean p0) {}

    public void setMaxEvents(int p0) {}

    public void setMaxEventsIsSet(boolean p0) {}

    public void unsetLastEvent() {}

    public void unsetMaxEvents() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        LAST_EVENT, MAX_EVENTS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static NotificationEventRequest._Fields findByName(String p0) {
            return null;
        }

        public static NotificationEventRequest._Fields findByThriftId(int p0) {
            return null;
        }

        public static NotificationEventRequest._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
