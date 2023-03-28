// Generated automatically from org.apache.hadoop.hive.metastore.api.FieldSchema for testing
// purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class FieldSchema implements Cloneable, Comparable<FieldSchema>, Serializable,
        TBase<FieldSchema, FieldSchema._Fields> {
    public FieldSchema deepCopy() {
        return null;
    }

    public FieldSchema() {}

    public FieldSchema(FieldSchema p0) {}

    public FieldSchema(String p0, String p1, String p2) {}

    public FieldSchema._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(FieldSchema._Fields p0) {
        return null;
    }

    public String getComment() {
        return null;
    }

    public String getName() {
        return null;
    }

    public String getType() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(FieldSchema p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(FieldSchema._Fields p0) {
        return false;
    }

    public boolean isSetComment() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public boolean isSetType() {
        return false;
    }

    public int compareTo(FieldSchema p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<FieldSchema._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setComment(String p0) {}

    public void setCommentIsSet(boolean p0) {}

    public void setFieldValue(FieldSchema._Fields p0, Object p1) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void setType(String p0) {}

    public void setTypeIsSet(boolean p0) {}

    public void unsetComment() {}

    public void unsetName() {}

    public void unsetType() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        COMMENT, NAME, TYPE;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static FieldSchema._Fields findByName(String p0) {
            return null;
        }

        public static FieldSchema._Fields findByThriftId(int p0) {
            return null;
        }

        public static FieldSchema._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
