// Generated automatically from org.apache.hadoop.hive.metastore.api.NotificationEventResponse for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.NotificationEvent;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class NotificationEventResponse implements Cloneable, Comparable<NotificationEventResponse>,
        Serializable, TBase<NotificationEventResponse, NotificationEventResponse._Fields> {
    public Iterator<NotificationEvent> getEventsIterator() {
        return null;
    }

    public List<NotificationEvent> getEvents() {
        return null;
    }

    public NotificationEventResponse deepCopy() {
        return null;
    }

    public NotificationEventResponse() {}

    public NotificationEventResponse(List<NotificationEvent> p0) {}

    public NotificationEventResponse(NotificationEventResponse p0) {}

    public NotificationEventResponse._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(NotificationEventResponse._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(NotificationEventResponse p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(NotificationEventResponse._Fields p0) {
        return false;
    }

    public boolean isSetEvents() {
        return false;
    }

    public int compareTo(NotificationEventResponse p0) {
        return 0;
    }

    public int getEventsSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<NotificationEventResponse._Fields, FieldMetaData> metaDataMap =
            null;

    public void addToEvents(NotificationEvent p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setEvents(List<NotificationEvent> p0) {}

    public void setEventsIsSet(boolean p0) {}

    public void setFieldValue(NotificationEventResponse._Fields p0, Object p1) {}

    public void unsetEvents() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        EVENTS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static NotificationEventResponse._Fields findByName(String p0) {
            return null;
        }

        public static NotificationEventResponse._Fields findByThriftId(int p0) {
            return null;
        }

        public static NotificationEventResponse._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
