// Generated automatically from org.apache.hadoop.hive.metastore.api.PartitionSpec for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.PartitionListComposingSpec;
import org.apache.hadoop.hive.metastore.api.PartitionSpecWithSharedSD;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class PartitionSpec implements Cloneable, Comparable<PartitionSpec>, Serializable,
        TBase<PartitionSpec, PartitionSpec._Fields> {
    public Object getFieldValue(PartitionSpec._Fields p0) {
        return null;
    }

    public PartitionListComposingSpec getPartitionList() {
        return null;
    }

    public PartitionSpec deepCopy() {
        return null;
    }

    public PartitionSpec() {}

    public PartitionSpec(PartitionSpec p0) {}

    public PartitionSpec(String p0, String p1, String p2) {}

    public PartitionSpec._Fields fieldForId(int p0) {
        return null;
    }

    public PartitionSpecWithSharedSD getSharedSDPartitionSpec() {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getRootPath() {
        return null;
    }

    public String getTableName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(PartitionSpec p0) {
        return false;
    }

    public boolean isSet(PartitionSpec._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetPartitionList() {
        return false;
    }

    public boolean isSetRootPath() {
        return false;
    }

    public boolean isSetSharedSDPartitionSpec() {
        return false;
    }

    public boolean isSetTableName() {
        return false;
    }

    public int compareTo(PartitionSpec p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<PartitionSpec._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(PartitionSpec._Fields p0, Object p1) {}

    public void setPartitionList(PartitionListComposingSpec p0) {}

    public void setPartitionListIsSet(boolean p0) {}

    public void setRootPath(String p0) {}

    public void setRootPathIsSet(boolean p0) {}

    public void setSharedSDPartitionSpec(PartitionSpecWithSharedSD p0) {}

    public void setSharedSDPartitionSpecIsSet(boolean p0) {}

    public void setTableName(String p0) {}

    public void setTableNameIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDbName() {}

    public void unsetPartitionList() {}

    public void unsetRootPath() {}

    public void unsetSharedSDPartitionSpec() {}

    public void unsetTableName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DB_NAME, PARTITION_LIST, ROOT_PATH, SHARED_SDPARTITION_SPEC, TABLE_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static PartitionSpec._Fields findByName(String p0) {
            return null;
        }

        public static PartitionSpec._Fields findByThriftId(int p0) {
            return null;
        }

        public static PartitionSpec._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
