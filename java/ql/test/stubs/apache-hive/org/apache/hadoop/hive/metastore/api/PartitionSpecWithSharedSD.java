// Generated automatically from org.apache.hadoop.hive.metastore.api.PartitionSpecWithSharedSD for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PartitionWithoutSD;
import org.apache.hadoop.hive.metastore.api.StorageDescriptor;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PartitionSpecWithSharedSD implements Cloneable, Comparable<PartitionSpecWithSharedSD>,
        Serializable, TBase<PartitionSpecWithSharedSD, PartitionSpecWithSharedSD._Fields> {
    public Iterator<PartitionWithoutSD> getPartitionsIterator() {
        return null;
    }

    public List<PartitionWithoutSD> getPartitions() {
        return null;
    }

    public Object getFieldValue(PartitionSpecWithSharedSD._Fields p0) {
        return null;
    }

    public PartitionSpecWithSharedSD deepCopy() {
        return null;
    }

    public PartitionSpecWithSharedSD() {}

    public PartitionSpecWithSharedSD(List<PartitionWithoutSD> p0, StorageDescriptor p1) {}

    public PartitionSpecWithSharedSD(PartitionSpecWithSharedSD p0) {}

    public PartitionSpecWithSharedSD._Fields fieldForId(int p0) {
        return null;
    }

    public StorageDescriptor getSd() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PartitionSpecWithSharedSD p0) {
        return false;
    }

    public boolean isSet(PartitionSpecWithSharedSD._Fields p0) {
        return false;
    }

    public boolean isSetPartitions() {
        return false;
    }

    public boolean isSetSd() {
        return false;
    }

    public int compareTo(PartitionSpecWithSharedSD p0) {
        return 0;
    }

    public int getPartitionsSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PartitionSpecWithSharedSD._Fields, FieldMetaData> metaDataMap =
            null;

    public void addToPartitions(PartitionWithoutSD p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(PartitionSpecWithSharedSD._Fields p0, Object p1) {}

    public void setPartitions(List<PartitionWithoutSD> p0) {}

    public void setPartitionsIsSet(boolean p0) {}

    public void setSd(StorageDescriptor p0) {}

    public void setSdIsSet(boolean p0) {}

    public void unsetPartitions() {}

    public void unsetSd() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        PARTITIONS, SD;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PartitionSpecWithSharedSD._Fields findByName(String p0) {
            return null;
        }

        public static PartitionSpecWithSharedSD._Fields findByThriftId(int p0) {
            return null;
        }

        public static PartitionSpecWithSharedSD._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
