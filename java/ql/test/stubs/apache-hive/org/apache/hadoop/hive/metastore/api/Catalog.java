// Generated automatically from org.apache.hadoop.hive.metastore.api.Catalog for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Catalog
        implements Cloneable, Comparable<Catalog>, Serializable, TBase<Catalog, Catalog._Fields> {
    public Catalog deepCopy() {
        return null;
    }

    public Catalog() {}

    public Catalog(Catalog p0) {}

    public Catalog(String p0, String p1) {}

    public Catalog._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(Catalog._Fields p0) {
        return null;
    }

    public String getDescription() {
        return null;
    }

    public String getLocationUri() {
        return null;
    }

    public String getName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Catalog p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(Catalog._Fields p0) {
        return false;
    }

    public boolean isSetDescription() {
        return false;
    }

    public boolean isSetLocationUri() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public int compareTo(Catalog p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Catalog._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setDescription(String p0) {}

    public void setDescriptionIsSet(boolean p0) {}

    public void setFieldValue(Catalog._Fields p0, Object p1) {}

    public void setLocationUri(String p0) {}

    public void setLocationUriIsSet(boolean p0) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void unsetDescription() {}

    public void unsetLocationUri() {}

    public void unsetName() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        DESCRIPTION, LOCATION_URI, NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Catalog._Fields findByName(String p0) {
            return null;
        }

        public static Catalog._Fields findByThriftId(int p0) {
            return null;
        }

        public static Catalog._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
