// Generated automatically from org.apache.hadoop.hive.metastore.api.Table for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.CreationMetadata;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.PrincipalPrivilegeSet;
import org.apache.hadoop.hive.metastore.api.PrincipalType;
import org.apache.hadoop.hive.metastore.api.StorageDescriptor;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Table
        implements Cloneable, Comparable<Table>, Serializable, TBase<Table, Table._Fields> {
    public CreationMetadata getCreationMetadata() {
        return null;
    }

    public Iterator<FieldSchema> getPartitionKeysIterator() {
        return null;
    }

    public List<FieldSchema> getPartitionKeys() {
        return null;
    }

    public Map<String, String> getParameters() {
        return null;
    }

    public Object getFieldValue(Table._Fields p0) {
        return null;
    }

    public PrincipalPrivilegeSet getPrivileges() {
        return null;
    }

    public PrincipalType getOwnerType() {
        return null;
    }

    public StorageDescriptor getSd() {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getOwner() {
        return null;
    }

    public String getTableName() {
        return null;
    }

    public String getTableType() {
        return null;
    }

    public String getViewExpandedText() {
        return null;
    }

    public String getViewOriginalText() {
        return null;
    }

    public String toString() {
        return null;
    }

    public Table deepCopy() {
        return null;
    }

    public Table() {}

    public Table(String p0, String p1, String p2, int p3, int p4, int p5, StorageDescriptor p6,
            List<FieldSchema> p7, Map<String, String> p8, String p9, String p10, String p11) {}

    public Table(Table p0) {}

    public Table._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(Table p0) {
        return false;
    }

    public boolean isRewriteEnabled() {
        return false;
    }

    public boolean isSet(Table._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetCreateTime() {
        return false;
    }

    public boolean isSetCreationMetadata() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetLastAccessTime() {
        return false;
    }

    public boolean isSetOwner() {
        return false;
    }

    public boolean isSetOwnerType() {
        return false;
    }

    public boolean isSetParameters() {
        return false;
    }

    public boolean isSetPartitionKeys() {
        return false;
    }

    public boolean isSetPrivileges() {
        return false;
    }

    public boolean isSetRetention() {
        return false;
    }

    public boolean isSetRewriteEnabled() {
        return false;
    }

    public boolean isSetSd() {
        return false;
    }

    public boolean isSetTableName() {
        return false;
    }

    public boolean isSetTableType() {
        return false;
    }

    public boolean isSetTemporary() {
        return false;
    }

    public boolean isSetViewExpandedText() {
        return false;
    }

    public boolean isSetViewOriginalText() {
        return false;
    }

    public boolean isTemporary() {
        return false;
    }

    public int compareTo(Table p0) {
        return 0;
    }

    public int getCreateTime() {
        return 0;
    }

    public int getLastAccessTime() {
        return 0;
    }

    public int getParametersSize() {
        return 0;
    }

    public int getPartitionKeysSize() {
        return 0;
    }

    public int getRetention() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Table._Fields, FieldMetaData> metaDataMap = null;

    public void addToPartitionKeys(FieldSchema p0) {}

    public void clear() {}

    public void putToParameters(String p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setCreateTime(int p0) {}

    public void setCreateTimeIsSet(boolean p0) {}

    public void setCreationMetadata(CreationMetadata p0) {}

    public void setCreationMetadataIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(Table._Fields p0, Object p1) {}

    public void setLastAccessTime(int p0) {}

    public void setLastAccessTimeIsSet(boolean p0) {}

    public void setOwner(String p0) {}

    public void setOwnerIsSet(boolean p0) {}

    public void setOwnerType(PrincipalType p0) {}

    public void setOwnerTypeIsSet(boolean p0) {}

    public void setParameters(Map<String, String> p0) {}

    public void setParametersIsSet(boolean p0) {}

    public void setPartitionKeys(List<FieldSchema> p0) {}

    public void setPartitionKeysIsSet(boolean p0) {}

    public void setPrivileges(PrincipalPrivilegeSet p0) {}

    public void setPrivilegesIsSet(boolean p0) {}

    public void setRetention(int p0) {}

    public void setRetentionIsSet(boolean p0) {}

    public void setRewriteEnabled(boolean p0) {}

    public void setRewriteEnabledIsSet(boolean p0) {}

    public void setSd(StorageDescriptor p0) {}

    public void setSdIsSet(boolean p0) {}

    public void setTableName(String p0) {}

    public void setTableNameIsSet(boolean p0) {}

    public void setTableType(String p0) {}

    public void setTableTypeIsSet(boolean p0) {}

    public void setTemporary(boolean p0) {}

    public void setTemporaryIsSet(boolean p0) {}

    public void setViewExpandedText(String p0) {}

    public void setViewExpandedTextIsSet(boolean p0) {}

    public void setViewOriginalText(String p0) {}

    public void setViewOriginalTextIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetCreateTime() {}

    public void unsetCreationMetadata() {}

    public void unsetDbName() {}

    public void unsetLastAccessTime() {}

    public void unsetOwner() {}

    public void unsetOwnerType() {}

    public void unsetParameters() {}

    public void unsetPartitionKeys() {}

    public void unsetPrivileges() {}

    public void unsetRetention() {}

    public void unsetRewriteEnabled() {}

    public void unsetSd() {}

    public void unsetTableName() {}

    public void unsetTableType() {}

    public void unsetTemporary() {}

    public void unsetViewExpandedText() {}

    public void unsetViewOriginalText() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, CREATE_TIME, CREATION_METADATA, DB_NAME, LAST_ACCESS_TIME, OWNER, OWNER_TYPE, PARAMETERS, PARTITION_KEYS, PRIVILEGES, RETENTION, REWRITE_ENABLED, SD, TABLE_NAME, TABLE_TYPE, TEMPORARY, VIEW_EXPANDED_TEXT, VIEW_ORIGINAL_TEXT;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Table._Fields findByName(String p0) {
            return null;
        }

        public static Table._Fields findByThriftId(int p0) {
            return null;
        }

        public static Table._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
