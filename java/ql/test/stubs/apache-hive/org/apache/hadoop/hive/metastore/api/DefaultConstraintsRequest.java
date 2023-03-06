// Generated automatically from org.apache.hadoop.hive.metastore.api.DefaultConstraintsRequest for
// testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class DefaultConstraintsRequest implements Cloneable, Comparable<DefaultConstraintsRequest>,
        Serializable, TBase<DefaultConstraintsRequest, DefaultConstraintsRequest._Fields> {
    public DefaultConstraintsRequest deepCopy() {
        return null;
    }

    public DefaultConstraintsRequest() {}

    public DefaultConstraintsRequest(DefaultConstraintsRequest p0) {}

    public DefaultConstraintsRequest(String p0, String p1, String p2) {}

    public DefaultConstraintsRequest._Fields fieldForId(int p0) {
        return null;
    }

    public Object getFieldValue(DefaultConstraintsRequest._Fields p0) {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getDb_name() {
        return null;
    }

    public String getTbl_name() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(DefaultConstraintsRequest p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(DefaultConstraintsRequest._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetDb_name() {
        return false;
    }

    public boolean isSetTbl_name() {
        return false;
    }

    public int compareTo(DefaultConstraintsRequest p0) {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<DefaultConstraintsRequest._Fields, FieldMetaData> metaDataMap =
            null;

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setDb_name(String p0) {}

    public void setDb_nameIsSet(boolean p0) {}

    public void setFieldValue(DefaultConstraintsRequest._Fields p0, Object p1) {}

    public void setTbl_name(String p0) {}

    public void setTbl_nameIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetDb_name() {}

    public void unsetTbl_name() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, DB_NAME, TBL_NAME;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static DefaultConstraintsRequest._Fields findByName(String p0) {
            return null;
        }

        public static DefaultConstraintsRequest._Fields findByThriftId(int p0) {
            return null;
        }

        public static DefaultConstraintsRequest._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
