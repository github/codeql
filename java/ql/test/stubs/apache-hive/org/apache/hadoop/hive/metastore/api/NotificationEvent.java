// Generated automatically from org.apache.hadoop.hive.metastore.api.NotificationEvent for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class NotificationEvent implements Cloneable, Comparable<NotificationEvent>, Serializable,
        TBase<NotificationEvent, NotificationEvent._Fields> {
    public NotificationEvent deepCopy() {
        return null;
    }

    public NotificationEvent() {}

    public NotificationEvent(NotificationEvent p0) {}

    public NotificationEvent(long p0, int p1, String p2, String p3) {}

    public NotificationEvent._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(NotificationEvent._Fields p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getEventType() {
        return null;
    }

    public String getMessage() {
        return null;
    }

    public String getMessageFormat() {
        return null;
    }

    public String getTableName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(NotificationEvent p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(NotificationEvent._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetEventId() {
        return false;
    }

    public boolean isSetEventTime() {
        return false;
    }

    public boolean isSetEventType() {
        return false;
    }

    public boolean isSetMessage() {
        return false;
    }

    public boolean isSetMessageFormat() {
        return false;
    }

    public boolean isSetTableName() {
        return false;
    }

    public int compareTo(NotificationEvent p0) {
        return 0;
    }

    public int getEventTime() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getEventId() {
        return 0;
    }

    public static java.util.Map<NotificationEvent._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setEventId(long p0) {}

    public void setEventIdIsSet(boolean p0) {}

    public void setEventTime(int p0) {}

    public void setEventTimeIsSet(boolean p0) {}

    public void setEventType(String p0) {}

    public void setEventTypeIsSet(boolean p0) {}

    public void setFieldValue(NotificationEvent._Fields p0, Object p1) {}

    public void setMessage(String p0) {}

    public void setMessageFormat(String p0) {}

    public void setMessageFormatIsSet(boolean p0) {}

    public void setMessageIsSet(boolean p0) {}

    public void setTableName(String p0) {}

    public void setTableNameIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDbName() {}

    public void unsetEventId() {}

    public void unsetEventTime() {}

    public void unsetEventType() {}

    public void unsetMessage() {}

    public void unsetMessageFormat() {}

    public void unsetTableName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DB_NAME, EVENT_ID, EVENT_TIME, EVENT_TYPE, MESSAGE, MESSAGE_FORMAT, TABLE_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static NotificationEvent._Fields findByName(String p0) {
            return null;
        }

        public static NotificationEvent._Fields findByThriftId(int p0) {
            return null;
        }

        public static NotificationEvent._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
