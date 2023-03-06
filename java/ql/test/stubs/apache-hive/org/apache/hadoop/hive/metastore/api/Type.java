// Generated automatically from org.apache.hadoop.hive.metastore.api.Type for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Type
        implements Cloneable, Serializable, TBase<Type, Type._Fields>, java.lang.Comparable<Type> {
    public Iterator<FieldSchema> getFieldsIterator() {
        return null;
    }

    public List<FieldSchema> getFields() {
        return null;
    }

    public Object getFieldValue(Type._Fields p0) {
        return null;
    }

    public String getName() {
        return null;
    }

    public String getType1() {
        return null;
    }

    public String getType2() {
        return null;
    }

    public String toString() {
        return null;
    }

    public Type deepCopy() {
        return null;
    }

    public Type() {}

    public Type(String p0) {}

    public Type(Type p0) {}

    public Type._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(Type p0) {
        return false;
    }

    public boolean isSet(Type._Fields p0) {
        return false;
    }

    public boolean isSetFields() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public boolean isSetType1() {
        return false;
    }

    public boolean isSetType2() {
        return false;
    }

    public int compareTo(Type p0) {
        return 0;
    }

    public int getFieldsSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Type._Fields, FieldMetaData> metaDataMap = null;

    public void addToFields(FieldSchema p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(Type._Fields p0, Object p1) {}

    public void setFields(List<FieldSchema> p0) {}

    public void setFieldsIsSet(boolean p0) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void setType1(String p0) {}

    public void setType1IsSet(boolean p0) {}

    public void setType2(String p0) {}

    public void setType2IsSet(boolean p0) {}

    public void unsetFields() {}

    public void unsetName() {}

    public void unsetType1() {}

    public void unsetType2() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        FIELDS, NAME, TYPE1, TYPE2;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Type._Fields findByName(String p0) {
            return null;
        }

        public static Type._Fields findByThriftId(int p0) {
            return null;
        }

        public static Type._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
