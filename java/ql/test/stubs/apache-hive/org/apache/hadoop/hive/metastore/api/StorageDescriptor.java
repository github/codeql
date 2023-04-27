// Generated automatically from org.apache.hadoop.hive.metastore.api.StorageDescriptor for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.Order;
import org.apache.hadoop.hive.metastore.api.SerDeInfo;
import org.apache.hadoop.hive.metastore.api.SkewedInfo;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class StorageDescriptor implements Cloneable, Comparable<StorageDescriptor>, Serializable,
        TBase<StorageDescriptor, StorageDescriptor._Fields> {
    public Iterator<FieldSchema> getColsIterator() {
        return null;
    }

    public Iterator<Order> getSortColsIterator() {
        return null;
    }

    public Iterator<String> getBucketColsIterator() {
        return null;
    }

    public List<FieldSchema> getCols() {
        return null;
    }

    public List<Order> getSortCols() {
        return null;
    }

    public List<String> getBucketCols() {
        return null;
    }

    public Map<String, String> getParameters() {
        return null;
    }

    public Object getFieldValue(StorageDescriptor._Fields p0) {
        return null;
    }

    public SerDeInfo getSerdeInfo() {
        return null;
    }

    public SkewedInfo getSkewedInfo() {
        return null;
    }

    public StorageDescriptor deepCopy() {
        return null;
    }

    public StorageDescriptor() {}

    public StorageDescriptor(List<FieldSchema> p0, String p1, String p2, String p3, boolean p4,
            int p5, SerDeInfo p6, List<String> p7, List<Order> p8, Map<String, String> p9) {}

    public StorageDescriptor(StorageDescriptor p0) {}

    public StorageDescriptor._Fields fieldForId(int p0) {
        return null;
    }

    public String getInputFormat() {
        return null;
    }

    public String getLocation() {
        return null;
    }

    public String getOutputFormat() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(StorageDescriptor p0) {
        return false;
    }

    public boolean isCompressed() {
        return false;
    }

    public boolean isSet(StorageDescriptor._Fields p0) {
        return false;
    }

    public boolean isSetBucketCols() {
        return false;
    }

    public boolean isSetCols() {
        return false;
    }

    public boolean isSetCompressed() {
        return false;
    }

    public boolean isSetInputFormat() {
        return false;
    }

    public boolean isSetLocation() {
        return false;
    }

    public boolean isSetNumBuckets() {
        return false;
    }

    public boolean isSetOutputFormat() {
        return false;
    }

    public boolean isSetParameters() {
        return false;
    }

    public boolean isSetSerdeInfo() {
        return false;
    }

    public boolean isSetSkewedInfo() {
        return false;
    }

    public boolean isSetSortCols() {
        return false;
    }

    public boolean isSetStoredAsSubDirectories() {
        return false;
    }

    public boolean isStoredAsSubDirectories() {
        return false;
    }

    public int compareTo(StorageDescriptor p0) {
        return 0;
    }

    public int getBucketColsSize() {
        return 0;
    }

    public int getColsSize() {
        return 0;
    }

    public int getNumBuckets() {
        return 0;
    }

    public int getParametersSize() {
        return 0;
    }

    public int getSortColsSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<StorageDescriptor._Fields, FieldMetaData> metaDataMap = null;

    public void addToBucketCols(String p0) {}

    public void addToCols(FieldSchema p0) {}

    public void addToSortCols(Order p0) {}

    public void clear() {}

    public void putToParameters(String p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setBucketCols(List<String> p0) {}

    public void setBucketColsIsSet(boolean p0) {}

    public void setCols(List<FieldSchema> p0) {}

    public void setColsIsSet(boolean p0) {}

    public void setCompressed(boolean p0) {}

    public void setCompressedIsSet(boolean p0) {}

    public void setFieldValue(StorageDescriptor._Fields p0, Object p1) {}

    public void setInputFormat(String p0) {}

    public void setInputFormatIsSet(boolean p0) {}

    public void setLocation(String p0) {}

    public void setLocationIsSet(boolean p0) {}

    public void setNumBuckets(int p0) {}

    public void setNumBucketsIsSet(boolean p0) {}

    public void setOutputFormat(String p0) {}

    public void setOutputFormatIsSet(boolean p0) {}

    public void setParameters(Map<String, String> p0) {}

    public void setParametersIsSet(boolean p0) {}

    public void setSerdeInfo(SerDeInfo p0) {}

    public void setSerdeInfoIsSet(boolean p0) {}

    public void setSkewedInfo(SkewedInfo p0) {}

    public void setSkewedInfoIsSet(boolean p0) {}

    public void setSortCols(List<Order> p0) {}

    public void setSortColsIsSet(boolean p0) {}

    public void setStoredAsSubDirectories(boolean p0) {}

    public void setStoredAsSubDirectoriesIsSet(boolean p0) {}

    public void unsetBucketCols() {}

    public void unsetCols() {}

    public void unsetCompressed() {}

    public void unsetInputFormat() {}

    public void unsetLocation() {}

    public void unsetNumBuckets() {}

    public void unsetOutputFormat() {}

    public void unsetParameters() {}

    public void unsetSerdeInfo() {}

    public void unsetSkewedInfo() {}

    public void unsetSortCols() {}

    public void unsetStoredAsSubDirectories() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        BUCKET_COLS, COLS, COMPRESSED, INPUT_FORMAT, LOCATION, NUM_BUCKETS, OUTPUT_FORMAT, PARAMETERS, SERDE_INFO, SKEWED_INFO, SORT_COLS, STORED_AS_SUB_DIRECTORIES;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static StorageDescriptor._Fields findByName(String p0) {
            return null;
        }

        public static StorageDescriptor._Fields findByThriftId(int p0) {
            return null;
        }

        public static StorageDescriptor._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
