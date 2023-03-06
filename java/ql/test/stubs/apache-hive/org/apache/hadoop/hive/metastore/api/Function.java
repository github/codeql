// Generated automatically from org.apache.hadoop.hive.metastore.api.Function for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.FunctionType;
import org.apache.hadoop.hive.metastore.api.PrincipalType;
import org.apache.hadoop.hive.metastore.api.ResourceUri;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class Function implements Cloneable, Comparable<Function>, Serializable,
        TBase<Function, Function._Fields> {
    public Function deepCopy() {
        return null;
    }

    public Function() {}

    public Function(Function p0) {}

    public Function(String p0, String p1, String p2, String p3, PrincipalType p4, int p5,
            FunctionType p6, List<ResourceUri> p7) {}

    public Function._Fields fieldForId(int p0) {
        return null;
    }

    public FunctionType getFunctionType() {
        return null;
    }

    public Iterator<ResourceUri> getResourceUrisIterator() {
        return null;
    }

    public List<ResourceUri> getResourceUris() {
        return null;
    }

    public Object getFieldValue(Function._Fields p0) {
        return null;
    }

    public PrincipalType getOwnerType() {
        return null;
    }

    public String getCatName() {
        return null;
    }

    public String getClassName() {
        return null;
    }

    public String getDbName() {
        return null;
    }

    public String getFunctionName() {
        return null;
    }

    public String getOwnerName() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Function p0) {
        return false;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean isSet(Function._Fields p0) {
        return false;
    }

    public boolean isSetCatName() {
        return false;
    }

    public boolean isSetClassName() {
        return false;
    }

    public boolean isSetCreateTime() {
        return false;
    }

    public boolean isSetDbName() {
        return false;
    }

    public boolean isSetFunctionName() {
        return false;
    }

    public boolean isSetFunctionType() {
        return false;
    }

    public boolean isSetOwnerName() {
        return false;
    }

    public boolean isSetOwnerType() {
        return false;
    }

    public boolean isSetResourceUris() {
        return false;
    }

    public int compareTo(Function p0) {
        return 0;
    }

    public int getCreateTime() {
        return 0;
    }

    public int getResourceUrisSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<Function._Fields, FieldMetaData> metaDataMap = null;

    public void addToResourceUris(ResourceUri p0) {}

    public void clear() {}

    public void read(TProtocol p0) {}

    public void setCatName(String p0) {}

    public void setCatNameIsSet(boolean p0) {}

    public void setClassName(String p0) {}

    public void setClassNameIsSet(boolean p0) {}

    public void setCreateTime(int p0) {}

    public void setCreateTimeIsSet(boolean p0) {}

    public void setDbName(String p0) {}

    public void setDbNameIsSet(boolean p0) {}

    public void setFieldValue(Function._Fields p0, Object p1) {}

    public void setFunctionName(String p0) {}

    public void setFunctionNameIsSet(boolean p0) {}

    public void setFunctionType(FunctionType p0) {}

    public void setFunctionTypeIsSet(boolean p0) {}

    public void setOwnerName(String p0) {}

    public void setOwnerNameIsSet(boolean p0) {}

    public void setOwnerType(PrincipalType p0) {}

    public void setOwnerTypeIsSet(boolean p0) {}

    public void setResourceUris(List<ResourceUri> p0) {}

    public void setResourceUrisIsSet(boolean p0) {}

    public void unsetCatName() {}

    public void unsetClassName() {}

    public void unsetCreateTime() {}

    public void unsetDbName() {}

    public void unsetFunctionName() {}

    public void unsetFunctionType() {}

    public void unsetOwnerName() {}

    public void unsetOwnerType() {}

    public void unsetResourceUris() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        CAT_NAME, CLASS_NAME, CREATE_TIME, DB_NAME, FUNCTION_NAME, FUNCTION_TYPE, OWNER_NAME, OWNER_TYPE, RESOURCE_URIS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static Function._Fields findByName(String p0) {
            return null;
        }

        public static Function._Fields findByThriftId(int p0) {
            return null;
        }

        public static Function._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
