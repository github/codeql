// Generated automatically from org.apache.hadoop.hive.metastore.api.MetaException for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TException;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class MetaException extends TException implements Cloneable, Comparable<MetaException>,
        Serializable, TBase<MetaException, MetaException._Fields> {
    public MetaException deepCopy() {
        return null;
    }

    public MetaException() {}

    public MetaException(MetaException p0) {}

    public MetaException(String p0) {}

    public MetaException._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(MetaException._Fields p0) {
        return null;
    }

    public String getMessage() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(MetaException p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(MetaException._Fields p0) {
        return false;
    }

    public boolean isSetMessage() {
        return false;
    }

    public int compareTo(MetaException p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<MetaException._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(MetaException._Fields p0, Object p1) {}

    public void setMessage(String p0) {}

    public void setMessageIsSet(boolean p0) {}

    public void unsetMessage() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        MESSAGE;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static MetaException._Fields findByName(String p0) {
            return null;
        }

        public static MetaException._Fields findByThriftId(int p0) {
            return null;
        }

        public static MetaException._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
