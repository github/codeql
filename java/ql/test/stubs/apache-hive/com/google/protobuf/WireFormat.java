// Generated automatically from com.google.protobuf.WireFormat for testing purposes

package com.google.protobuf;


public class WireFormat
{
    protected WireFormat() {}
    public static int WIRETYPE_END_GROUP = 0;
    public static int WIRETYPE_FIXED32 = 0;
    public static int WIRETYPE_FIXED64 = 0;
    public static int WIRETYPE_LENGTH_DELIMITED = 0;
    public static int WIRETYPE_START_GROUP = 0;
    public static int WIRETYPE_VARINT = 0;
    public static int getTagFieldNumber(int p0){ return 0; }
    static public enum FieldType
    {
        BOOL, BYTES, DOUBLE, ENUM, FIXED32, FIXED64, FLOAT, GROUP, INT32, INT64, MESSAGE, SFIXED32, SFIXED64, SINT32, SINT64, STRING, UINT32, UINT64;
        private FieldType() {}
        public WireFormat.JavaType getJavaType(){ return null; }
        public boolean isPackable(){ return false; }
        public int getWireType(){ return 0; }
    }
    static public enum JavaType
    {
        BOOLEAN, BYTE_STRING, DOUBLE, ENUM, FLOAT, INT, LONG, MESSAGE, STRING;
        private JavaType() {}
    }
}
