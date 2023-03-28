// Generated automatically from org.apache.hadoop.hive.metastore.api.SchemaVersionDescriptor for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.ISchemaName;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class SchemaVersionDescriptor implements Cloneable, Comparable<SchemaVersionDescriptor>,
        Serializable, TBase<SchemaVersionDescriptor, SchemaVersionDescriptor._Fields> {
    public ISchemaName getSchema() {
        return null;
    }

    public Object getFieldValue(SchemaVersionDescriptor._Fields p0) {
        return null;
    }

    public SchemaVersionDescriptor deepCopy() {
        return null;
    }

    public SchemaVersionDescriptor() {}

    public SchemaVersionDescriptor(ISchemaName p0, int p1) {}

    public SchemaVersionDescriptor(SchemaVersionDescriptor p0) {}

    public SchemaVersionDescriptor._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(SchemaVersionDescriptor p0) {
        return false;
    }

    public boolean isSet(SchemaVersionDescriptor._Fields p0) {
        return false;
    }

    public boolean isSetSchema() {
        return false;
    }

    public boolean isSetVersion() {
        return false;
    }

    public int compareTo(SchemaVersionDescriptor p0) {
        return 0;
    }

    public int getVersion() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<SchemaVersionDescriptor._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setFieldValue(SchemaVersionDescriptor._Fields p0, Object p1) {}

    public void setSchema(ISchemaName p0) {}

    public void setSchemaIsSet(boolean p0) {}

    public void setVersion(int p0) {}

    public void setVersionIsSet(boolean p0) {}

    public void unsetSchema() {}

    public void unsetVersion() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        SCHEMA, VERSION;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static SchemaVersionDescriptor._Fields findByName(String p0) {
            return null;
        }

        public static SchemaVersionDescriptor._Fields findByThriftId(int p0) {
            return null;
        }

        public static SchemaVersionDescriptor._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
