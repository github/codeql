// Generated automatically from org.apache.hadoop.hive.metastore.api.ISchema for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.SchemaCompatibility;
import org.apache.hadoop.hive.metastore.api.SchemaType;
import org.apache.hadoop.hive.metastore.api.SchemaValidation;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class ISchema
        implements Cloneable, Comparable<ISchema>, Serializable, TBase<ISchema, ISchema._Fields> {
    public ISchema deepCopy() {
        return null;
    }

    public ISchema() {}

    public ISchema(ISchema p0) {}

    public ISchema(SchemaType p0, String p1, String p2, String p3, SchemaCompatibility p4,
            SchemaValidation p5, boolean p6) {}

    public ISchema._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(ISchema._Fields p0) {
        return null;
    }

    public SchemaCompatibility getCompatibility() {
        return null;
    }

    public SchemaType getSchemaType() {
        return null;
    }

    public SchemaValidation getValidationLevel() {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getDescription() {
        return null;
    }

    public String getName() {
        return null;
    }

    public String getSchemaGroup() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(ISchema p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isCanEvolve() {
        return false;
    }

    public boolean isSet(ISchema._Fields p0) {
        return false;
    }

    public boolean isSetCanEvolve() {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetCompatibility() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetDescription() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public boolean isSetSchemaGroup() {
        return false;
    }

    public boolean isSetSchemaType() {
        return false;
    }

    public boolean isSetValidationLevel() {
        return false;
    }

    public int compareTo(ISchema p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<ISchema._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCanEvolve(boolean p0) {}

    public void setCanEvolveIsSet(boolean p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setCompatibility(SchemaCompatibility p0) {}

    public void setCompatibilityIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setDescription(String p0) {}

    public void setDescriptionIsSet(boolean p0) {}

    public void setFieldValue(ISchema._Fields p0, Object p1) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void setSchemaGroup(String p0) {}

    public void setSchemaGroupIsSet(boolean p0) {}

    public void setSchemaType(SchemaType p0) {}

    public void setSchemaTypeIsSet(boolean p0) {}

    public void setValidationLevel(SchemaValidation p0) {}

    public void setValidationLevelIsSet(boolean p0) {}

    public void unsetCanEvolve() {}

    public void unsetCatName() {}

    public void unsetCompatibility() {}

    public void unsetDbName() {}

    public void unsetDescription() {}

    public void unsetName() {}

    public void unsetSchemaGroup() {}

    public void unsetSchemaType() {}

    public void unsetValidationLevel() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAN_EVOLVE, CAT_NAME, COMPATIBILITY, DB_NAME, DESCRIPTION, NAME, SCHEMA_GROUP, SCHEMA_TYPE, VALIDATION_LEVEL;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static ISchema._Fields findByName(String p0) {
            return null;
        }

        public static ISchema._Fields findByThriftId(int p0) {
            return null;
        }

        public static ISchema._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
