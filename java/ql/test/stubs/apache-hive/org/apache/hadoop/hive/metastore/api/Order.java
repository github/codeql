// Generated automatically from org.apache.hadoop.hive.metastore.api.Order for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Order
        implements Cloneable, Comparable<Order>, Serializable, TBase<Order, Order._Fields> {
    public Object getFieldValue(Order._Fields p0) {
        return null;
    }

    public Order deepCopy() {
        return null;
    }

    public Order() {}

    public Order(Order p0) {}

    public Order(String p0, int p1) {}

    public Order._Fields fieldForId(int p0) {
        return null;
    }

    public String getCol() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(Order p0) {
        return false;
    }

    public boolean isSet(Order._Fields p0) {
        return false;
    }

    public boolean isSetCol() {
        return false;
    }

    public boolean isSetOrder() {
        return false;
    }

    public int compareTo(Order p0) {
        return 0;
    }

    public int getOrder() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Order._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCol(String p0) {}

    public void setColIsSet(boolean p0) {}

    public void setFieldValue(Order._Fields p0, Object p1) {}

    public void setOrder(int p0) {}

    public void setOrderIsSet(boolean p0) {}

    public void unsetCol() {}

    public void unsetOrder() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        COL, ORDER;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Order._Fields findByName(String p0) {
            return null;
        }

        public static Order._Fields findByThriftId(int p0) {
            return null;
        }

        public static Order._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
