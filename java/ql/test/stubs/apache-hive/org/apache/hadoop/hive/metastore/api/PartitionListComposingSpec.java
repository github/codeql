// Generated automatically from org.apache.hadoop.hive.metastore.api.PartitionListComposingSpec for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.Partition;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PartitionListComposingSpec
        implements Cloneable, Comparable<PartitionListComposingSpec>, Serializable,
        TBase<PartitionListComposingSpec, PartitionListComposingSpec._Fields> {
    public Iterator<Partition> getPartitionsIterator() {
        return null;
    }

    public List<Partition> getPartitions() {
        return null;
    }

    public Object getFieldValue(PartitionListComposingSpec._Fields p0) {
        return null;
    }

    public PartitionListComposingSpec deepCopy() {
        return null;
    }

    public PartitionListComposingSpec() {}

    public PartitionListComposingSpec(List<Partition> p0) {}

    public PartitionListComposingSpec(PartitionListComposingSpec p0) {}

    public PartitionListComposingSpec._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PartitionListComposingSpec p0) {
        return false;
    }

    public boolean isSet(PartitionListComposingSpec._Fields p0) {
        return false;
    }

    public boolean isSetPartitions() {
        return false;
    }

    public int compareTo(PartitionListComposingSpec p0) {
        return 0;
    }

    public int getPartitionsSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PartitionListComposingSpec._Fields, FieldMetaData> metaDataMap =
            null;

    public void addToPartitions(Partition p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(PartitionListComposingSpec._Fields p0, Object p1) {}

    public void setPartitions(List<Partition> p0) {}

    public void setPartitionsIsSet(boolean p0) {}

    public void unsetPartitions() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        PARTITIONS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PartitionListComposingSpec._Fields findByName(String p0) {
            return null;
        }

        public static PartitionListComposingSpec._Fields findByThriftId(int p0) {
            return null;
        }

        public static PartitionListComposingSpec._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
