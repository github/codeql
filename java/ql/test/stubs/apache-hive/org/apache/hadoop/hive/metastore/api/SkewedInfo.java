// Generated automatically from org.apache.hadoop.hive.metastore.api.SkewedInfo for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class SkewedInfo implements Cloneable, Comparable<SkewedInfo>, Serializable,
        TBase<SkewedInfo, SkewedInfo._Fields> {
    public Iterator<List<String>> getSkewedColValuesIterator() {
        return null;
    }

    public Iterator<String> getSkewedColNamesIterator() {
        return null;
    }

    public List<List<String>> getSkewedColValues() {
        return null;
    }

    public List<String> getSkewedColNames() {
        return null;
    }

    public Map<List<String>, String> getSkewedColValueLocationMaps() {
        return null;
    }

    public Object getFieldValue(SkewedInfo._Fields p0) {
        return null;
    }

    public SkewedInfo deepCopy() {
        return null;
    }

    public SkewedInfo() {}

    public SkewedInfo(List<String> p0, List<List<String>> p1, Map<List<String>, String> p2) {}

    public SkewedInfo(SkewedInfo p0) {}

    public SkewedInfo._Fields fieldForId(int p0) {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(SkewedInfo p0) {
        return false;
    }

    public boolean isSet(SkewedInfo._Fields p0) {
        return false;
    }

    public boolean isSetSkewedColNames() {
        return false;
    }

    public boolean isSetSkewedColValueLocationMaps() {
        return false;
    }

    public boolean isSetSkewedColValues() {
        return false;
    }

    public int compareTo(SkewedInfo p0) {
        return 0;
    }

    public int getSkewedColNamesSize() {
        return 0;
    }

    public int getSkewedColValueLocationMapsSize() {
        return 0;
    }

    public int getSkewedColValuesSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<SkewedInfo._Fields, FieldMetaData> metaDataMap = null;

    public void addToSkewedColNames(String p0) {}

    public void addToSkewedColValues(List<String> p0) {}

    public void clear() {}

    public void putToSkewedColValueLocationMaps(List<String> p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setFieldValue(SkewedInfo._Fields p0, Object p1) {}

    public void setSkewedColNames(List<String> p0) {}

    public void setSkewedColNamesIsSet(boolean p0) {}

    public void setSkewedColValueLocationMaps(Map<List<String>, String> p0) {}

    public void setSkewedColValueLocationMapsIsSet(boolean p0) {}

    public void setSkewedColValues(List<List<String>> p0) {}

    public void setSkewedColValuesIsSet(boolean p0) {}

    public void unsetSkewedColNames() {}

    public void unsetSkewedColValueLocationMaps() {}

    public void unsetSkewedColValues() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        SKEWED_COL_NAMES, SKEWED_COL_VALUES, SKEWED_COL_VALUE_LOCATION_MAPS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static SkewedInfo._Fields findByName(String p0) {
            return null;
        }

        public static SkewedInfo._Fields findByThriftId(int p0) {
            return null;
        }

        public static SkewedInfo._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
