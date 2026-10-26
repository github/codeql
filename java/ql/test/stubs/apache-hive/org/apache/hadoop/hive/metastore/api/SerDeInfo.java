// Generated automatically from org.apache.hadoop.hive.metastore.api.SerDeInfo for testing purposes

package org.apache.hadoop.hive.metastore.api;

import java.io.Serializable;
import java.util.Map;
import org.apache.hadoop.hive.metastore.api.SerdeType;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.meta_data.FieldMetaData;
import org.apache.thrift.protocol.TProtocol;

public class SerDeInfo implements Cloneable, Comparable<SerDeInfo>, Serializable,
        TBase<SerDeInfo, SerDeInfo._Fields> {
    public Map<String, String> getParameters() {
        return null;
    }

    public Object getFieldValue(SerDeInfo._Fields p0) {
        return null;
    }

    public SerDeInfo deepCopy() {
        return null;
    }

    public SerDeInfo() {}

    public SerDeInfo(SerDeInfo p0) {}

    public SerDeInfo(String p0, String p1, Map<String, String> p2) {}

    public SerDeInfo._Fields fieldForId(int p0) {
        return null;
    }

    public SerdeType getSerdeType() {
        return null;
    }

    public String getDescription() {
        return null;
    }

    public String getDeserializerClass() {
        return null;
    }

    public String getName() {
        return null;
    }

    public String getSerializationLib() {
        return null;
    }

    public String getSerializerClass() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public boolean equals(SerDeInfo p0) {
        return false;
    }

    public boolean isSet(SerDeInfo._Fields p0) {
        return false;
    }

    public boolean isSetDescription() {
        return false;
    }

    public boolean isSetDeserializerClass() {
        return false;
    }

    public boolean isSetName() {
        return false;
    }

    public boolean isSetParameters() {
        return false;
    }

    public boolean isSetSerdeType() {
        return false;
    }

    public boolean isSetSerializationLib() {
        return false;
    }

    public boolean isSetSerializerClass() {
        return false;
    }

    public int compareTo(SerDeInfo p0) {
        return 0;
    }

    public int getParametersSize() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static java.util.Map<SerDeInfo._Fields, FieldMetaData> metaDataMap = null;

    public void clear() {}

    public void putToParameters(String p0, String p1) {}

    public void read(TProtocol p0) {}

    public void setDescription(String p0) {}

    public void setDescriptionIsSet(boolean p0) {}

    public void setDeserializerClass(String p0) {}

    public void setDeserializerClassIsSet(boolean p0) {}

    public void setFieldValue(SerDeInfo._Fields p0, Object p1) {}

    public void setName(String p0) {}

    public void setNameIsSet(boolean p0) {}

    public void setParameters(Map<String, String> p0) {}

    public void setParametersIsSet(boolean p0) {}

    public void setSerdeType(SerdeType p0) {}

    public void setSerdeTypeIsSet(boolean p0) {}

    public void setSerializationLib(String p0) {}

    public void setSerializationLibIsSet(boolean p0) {}

    public void setSerializerClass(String p0) {}

    public void setSerializerClassIsSet(boolean p0) {}

    public void unsetDescription() {}

    public void unsetDeserializerClass() {}

    public void unsetName() {}

    public void unsetParameters() {}

    public void unsetSerdeType() {}

    public void unsetSerializationLib() {}

    public void unsetSerializerClass() {}

    public void validate() {}

    public void write(TProtocol p0) {}

    static public enum _Fields implements TFieldIdEnum {
        DESCRIPTION, DESERIALIZER_CLASS, NAME, PARAMETERS, SERDE_TYPE, SERIALIZATION_LIB, SERIALIZER_CLASS;

        private _Fields() {}

        public String getFieldName() {
            return null;
        }

        public short getThriftFieldId() {
            return 0;
        }

        public static SerDeInfo._Fields findByName(String p0) {
            return null;
        }

        public static SerDeInfo._Fields findByThriftId(int p0) {
            return null;
        }

        public static SerDeInfo._Fields findByThriftIdOrThrow(int p0) {
            return null;
        }
    }
}
