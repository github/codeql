// Generated automatically from org.apache.hadoop.hive.metastore.api.PartitionValuesRow for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PartitionValuesRow implements Cloneable, Comparable<PartitionValuesRow>, Serializable,
        TBase<PartitionValuesRow, PartitionValuesRow._Fields> {
    public Iterator<String> getRowIterator() {
        return null;
    }

    public List<String> getRow() {
        return null;
    }

    public Object getFieldValue(PartitionValuesRow._Fields p0) {
        return null;
    }

    public PartitionValuesRow deepCopy() {
        return null;
    }

    public PartitionValuesRow() {}

    public PartitionValuesRow(List<String> p0) {}

    public PartitionValuesRow(PartitionValuesRow p0) {}

    public PartitionValuesRow._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PartitionValuesRow p0) {
        return false;
    }

    public boolean isSet(PartitionValuesRow._Fields p0) {
        return false;
    }

    public boolean isSetRow() {
        return false;
    }

    public int compareTo(PartitionValuesRow p0) {
        return 0;
    }

    public int getRowSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PartitionValuesRow._Fields, FieldMetaData> metaDataMap = null;

    public void addToRow(String p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(PartitionValuesRow._Fields p0, Object p1) {}

    public void setRow(List<String> p0) {}

    public void setRowIsSet(boolean p0) {}

    public void unsetRow() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        ROW;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PartitionValuesRow._Fields findByName(String p0) {
            return null;
        }

        public static PartitionValuesRow._Fields findByThriftId(int p0) {
            return null;
        }

        public static PartitionValuesRow._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
