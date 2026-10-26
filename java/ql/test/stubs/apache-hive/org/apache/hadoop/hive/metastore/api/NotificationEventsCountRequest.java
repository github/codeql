// Generated automatically from org.apache.hadoop.hive.metastore.api.NotificationEventsCountRequest
// for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class NotificationEventsCountRequest
        implements Cloneable, Comparable<NotificationEventsCountRequest>, Serializable,
        TBase<NotificationEventsCountRequest, NotificationEventsCountRequest._Fields> {
    public NotificationEventsCountRequest deepCopy() {
        return null;
    }

    public NotificationEventsCountRequest() {}

    public NotificationEventsCountRequest(NotificationEventsCountRequest p0) {}

    public NotificationEventsCountRequest(long p0, String p1) {}

    public NotificationEventsCountRequest._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(NotificationEventsCountRequest._Fields p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(NotificationEventsCountRequest p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(NotificationEventsCountRequest._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetFromEventId() {
        return false;
    }

    public int compareTo(NotificationEventsCountRequest p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getFromEventId() {
        return 0;
    }

    public static java.util.Map<NotificationEventsCountRequest._Fields, FieldMetaData> metaDataMap =
            null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(NotificationEventsCountRequest._Fields p0, Object p1) {}

    public void setFromEventId(long p0) {}

    public void setFromEventIdIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDbName() {}

    public void unsetFromEventId() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DB_NAME, FROM_EVENT_ID;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static NotificationEventsCountRequest._Fields findByName(String p0) {
            return null;
        }

        public static NotificationEventsCountRequest._Fields findByThriftId(int p0) {
            return null;
        }

        public static NotificationEventsCountRequest._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
