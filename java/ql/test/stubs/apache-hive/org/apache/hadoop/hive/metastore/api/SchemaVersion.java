// Generated automatically from org.apache.hadoop.hive.metastore.api.SchemaVersion for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.ISchemaName;
import org.apache.hadoop.hive.metastore.api.SchemaVersionState;
import org.apache.hadoop.hive.metastore.api.SerDeInfo;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class SchemaVersion implements Cloneable, Comparable<SchemaVersion>, Serializable,
        TBase<SchemaVersion, SchemaVersion._Fields> {
    public ISchemaName getSchema() {
        return null;
    }

    public Iterator<FieldSchema> getColsIterator() {
        return null;
    }

    public List<FieldSchema> getCols() {
        return null;
    }

    public Object getFieldValue(SchemaVersion._Fields p0) {
        return null;
    }

    public SchemaVersion deepCopy() {
        return null;
    }

    public SchemaVersion() {}

    public SchemaVersion(ISchemaName p0, int p1, long p2, List<FieldSchema> p3) {}

    public SchemaVersion(SchemaVersion p0) {}

    public SchemaVersion._Fields fieldForId(int p0) {
        return null;
    }

    public SchemaVersionState getState() {
        return null;
    }

    public SerDeInfo getSerDe() {
        return null;
    }

    public String getDescription() {
        return null;
    }

    public String getFingerprint() {
        return null;
    }

    public String getName() {
        return null;
    }

    public String getSchemaText() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(SchemaVersion p0) {
        return false;
    }

    public boolean isSet(SchemaVersion._Fields p0) {
        return false;
    }

    public boolean isSetCols() {
        return false;
    }

    public boolean isSetCreatedAt() {
        return false;
    }

    public boolean isSetDescription() {
        return false;
    }

    public boolean isSetFingerprint() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public boolean isSetSchema() {
        return false;
    }

    public boolean isSetSchemaText() {
        return false;
    }

    public boolean isSetSerDe() {
        return false;
    }

    public boolean isSetState() {
        return false;
    }

    public boolean isSetVersion() {
        return false;
    }

    public int compareTo(SchemaVersion p0) {
        return 0;
    }

    public int getColsSize() {
        return 0;
    }

    public int getVersion() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public long getCreatedAt() {
        return 0;
    }

    public static java.util.Map<SchemaVersion._Fields, FieldMetaData> metaDataMap = null;

    public void addToCols(FieldSchema p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCols(List<FieldSchema> p0) {}

    public void setColsIsSet(boolean p0) {}

    public void setCreatedAt(long p0) {}

    public void setCreatedAtIsSet(boolean p0) {}

    public void setDescription(String p0) {}

    public void setDescriptionIsSet(boolean p0) {}

    public void setFieldValue(SchemaVersion._Fields p0, Object p1) {}

    public void setFingerprint(String p0) {}

    public void setFingerprintIsSet(boolean p0) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void setSchema(ISchemaName p0) {}

    public void setSchemaIsSet(boolean p0) {}

    public void setSchemaText(String p0) {}

    public void setSchemaTextIsSet(boolean p0) {}

    public void setSerDe(SerDeInfo p0) {}

    public void setSerDeIsSet(boolean p0) {}

    public void setState(SchemaVersionState p0) {}

    public void setStateIsSet(boolean p0) {}

    public void setVersion(int p0) {}

    public void setVersionIsSet(boolean p0) {}

    public void unsetCols() {}

    public void unsetCreatedAt() {}

    public void unsetDescription() {}

    public void unsetFingerprint() {}

    public void unsetName() {}

    public void unsetSchema() {}

    public void unsetSchemaText() {}

    public void unsetSerDe() {}

    public void unsetState() {}

    public void unsetVersion() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        COLS, CREATED_AT, DESCRIPTION, FINGERPRINT, NAME, SCHEMA, SCHEMA_TEXT, SER_DE, STATE, VERSION;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static SchemaVersion._Fields findByName(String p0) {
            return null;
        }

        public static SchemaVersion._Fields findByThriftId(int p0) {
            return null;
        }

        public static SchemaVersion._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
