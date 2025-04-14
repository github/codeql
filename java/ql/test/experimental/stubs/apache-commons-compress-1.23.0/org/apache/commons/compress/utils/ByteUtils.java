// Generated automatically from org.apache.commons.compress.utils.ByteUtils for testing purposes

package org.apache.commons.compress.utils;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.InputStream;
import java.io.OutputStream;

public class ByteUtils
{
    protected ByteUtils() {}
    public static byte[] EMPTY_BYTE_ARRAY = null;
    public static long fromLittleEndian(ByteUtils.ByteSupplier p0, int p1){ return 0; }
    public static long fromLittleEndian(DataInput p0, int p1){ return 0; }
    public static long fromLittleEndian(InputStream p0, int p1){ return 0; }
    public static long fromLittleEndian(byte[] p0){ return 0; }
    public static long fromLittleEndian(byte[] p0, int p1, int p2){ return 0; }
    public static void toLittleEndian(ByteUtils.ByteConsumer p0, long p1, int p2){}
    public static void toLittleEndian(DataOutput p0, long p1, int p2){}
    public static void toLittleEndian(OutputStream p0, long p1, int p2){}
    public static void toLittleEndian(byte[] p0, long p1, int p2, int p3){}
    static public interface ByteConsumer
    {
        void accept(int p0);
    }
    static public interface ByteSupplier
    {
        int getAsByte();
    }
}
