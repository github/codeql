// Generated automatically from com.google.protobuf.Internal for testing purposes

package com.google.protobuf;

import com.google.protobuf.ByteString;

public class Internal
{
    public Internal(){}
    public static ByteString bytesDefaultValue(String p0){ return null; }
    public static String stringDefaultValue(String p0){ return null; }
    public static boolean isValidUtf8(ByteString p0){ return false; }
    static public interface EnumLite
    {
        int getNumber();
    }
    static public interface EnumLiteMap<T extends Internal.EnumLite>
    {
        T findValueByNumber(int p0);
    }
}
