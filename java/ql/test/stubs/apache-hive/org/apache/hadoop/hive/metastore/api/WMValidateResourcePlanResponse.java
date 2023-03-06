// Generated automatically from org.apache.hadoop.hive.metastore.api.WMValidateResourcePlanResponse
// for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class WMValidateResourcePlanResponse
        implements Cloneable, Comparable<WMValidateResourcePlanResponse>, Serializable,
        TBase<WMValidateResourcePlanResponse, WMValidateResourcePlanResponse._Fields> {
    public Iterator<String> getErrorsIterator() {
        return null;
    }

    public Iterator<String> getWarningsIterator() {
        return null;
    }

    public List<String> getErrors() {
        return null;
    }

    public List<String> getWarnings() {
        return null;
    }

    public Object getFieldValue(WMValidateResourcePlanResponse._Fields p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public WMValidateResourcePlanResponse deepCopy() {
        return null;
    }

    public WMValidateResourcePlanResponse() {}

    public WMValidateResourcePlanResponse(WMValidateResourcePlanResponse p0) {}

    public WMValidateResourcePlanResponse._Fields fieldForId(int p0) {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(WMValidateResourcePlanResponse p0) {
        return false;
    }

    public boolean isSet(WMValidateResourcePlanResponse._Fields p0) {
        return false;
    }

    public boolean isSetErrors() {
        return false;
    }

    public boolean isSetWarnings() {
        return false;
    }

    public int compareTo(WMValidateResourcePlanResponse p0) {
        return 0;
    }

    public int getErrorsSize() {
        return 0;
    }

    public int getWarningsSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<WMValidateResourcePlanResponse._Fields, FieldMetaData> metaDataMap =
            null;

    public void addToErrors(String p0) {}

    public void addToWarnings(String p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setErrors(List<String> p0) {}

    public void setErrorsIsSet(boolean p0) {}

    public void setFieldValue(WMValidateResourcePlanResponse._Fields p0, Object p1) {}

    public void setWarnings(List<String> p0) {}

    public void setWarningsIsSet(boolean p0) {}

    public void unsetErrors() {}

    public void unsetWarnings() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        ERRORS, WARNINGS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static WMValidateResourcePlanResponse._Fields findByName(String p0) {
            return null;
        }

        public static WMValidateResourcePlanResponse._Fields findByThriftId(int p0) {
            return null;
        }

        public static WMValidateResourcePlanResponse._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
