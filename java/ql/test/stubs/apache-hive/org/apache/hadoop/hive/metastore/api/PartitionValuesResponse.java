// Generated automatically from org.apache.hadoop.hive.metastore.api.PartitionValuesResponse for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PartitionValuesRow;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PartitionValuesResponse implements Cloneable, Comparable<PartitionValuesResponse>,
        Serializable, TBase<PartitionValuesResponse, PartitionValuesResponse._Fields> {
    public Iterator<PartitionValuesRow> getPartitionValuesIterator() {
        return null;
    }

    public List<PartitionValuesRow> getPartitionValues() {
        return null;
    }

    public Object getFieldValue(PartitionValuesResponse._Fields p0) {
        return null;
    }

    public PartitionValuesResponse deepCopy() {
        return null;
    }

    public PartitionValuesResponse() {}

    public PartitionValuesResponse(List<PartitionValuesRow> p0) {}

    public PartitionValuesResponse(PartitionValuesResponse p0) {}

    public PartitionValuesResponse._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PartitionValuesResponse p0) {
        return false;
    }

    public boolean isSet(PartitionValuesResponse._Fields p0) {
        return false;
    }

    public boolean isSetPartitionValues() {
        return false;
    }

    public int compareTo(PartitionValuesResponse p0) {
        return 0;
    }

    public int getPartitionValuesSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PartitionValuesResponse._Fields, FieldMetaData> metaDataMap = null;

    public void addToPartitionValues(PartitionValuesRow p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(PartitionValuesResponse._Fields p0, Object p1) {}

    public void setPartitionValues(List<PartitionValuesRow> p0) {}

    public void setPartitionValuesIsSet(boolean p0) {}

    public void unsetPartitionValues() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        PARTITION_VALUES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PartitionValuesResponse._Fields findByName(String p0) {
            return null;
        }

        public static PartitionValuesResponse._Fields findByThriftId(int p0) {
            return null;
        }

        public static PartitionValuesResponse._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
