// Generated automatically from io.netty.buffer.ByteBufUtil for testing purposes

package io.netty.buffer;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufAllocator;
import io.netty.util.AsciiString;
import java.nio.CharBuffer;
import java.nio.charset.Charset;

public class ByteBufUtil
{
    protected ByteBufUtil() {}
    public static ByteBuf encodeString(ByteBufAllocator p0, CharBuffer p1, Charset p2){ return null; }
    public static ByteBuf encodeString(ByteBufAllocator p0, CharBuffer p1, Charset p2, int p3){ return null; }
    public static ByteBuf ensureAccessible(ByteBuf p0){ return null; }
    public static ByteBuf readBytes(ByteBufAllocator p0, ByteBuf p1, int p2){ return null; }
    public static ByteBuf setShortBE(ByteBuf p0, int p1, int p2){ return null; }
    public static ByteBuf threadLocalDirectBuffer(){ return null; }
    public static ByteBuf writeAscii(ByteBufAllocator p0, CharSequence p1){ return null; }
    public static ByteBuf writeMediumBE(ByteBuf p0, int p1){ return null; }
    public static ByteBuf writeShortBE(ByteBuf p0, int p1){ return null; }
    public static ByteBuf writeUtf8(ByteBufAllocator p0, CharSequence p1){ return null; }
    public static String hexDump(ByteBuf p0){ return null; }
    public static String hexDump(ByteBuf p0, int p1, int p2){ return null; }
    public static String hexDump(byte[] p0){ return null; }
    public static String hexDump(byte[] p0, int p1, int p2){ return null; }
    public static String prettyHexDump(ByteBuf p0){ return null; }
    public static String prettyHexDump(ByteBuf p0, int p1, int p2){ return null; }
    public static boolean ensureWritableSuccess(int p0){ return false; }
    public static boolean equals(ByteBuf p0, ByteBuf p1){ return false; }
    public static boolean equals(ByteBuf p0, int p1, ByteBuf p2, int p3, int p4){ return false; }
    public static boolean isAccessible(ByteBuf p0){ return false; }
    public static boolean isText(ByteBuf p0, Charset p1){ return false; }
    public static boolean isText(ByteBuf p0, int p1, int p2, Charset p3){ return false; }
    public static byte decodeHexByte(CharSequence p0, int p1){ return 0; }
    public static byte[] decodeHexDump(CharSequence p0){ return null; }
    public static byte[] decodeHexDump(CharSequence p0, int p1, int p2){ return null; }
    public static byte[] getBytes(ByteBuf p0){ return null; }
    public static byte[] getBytes(ByteBuf p0, int p1, int p2){ return null; }
    public static byte[] getBytes(ByteBuf p0, int p1, int p2, boolean p3){ return null; }
    public static int compare(ByteBuf p0, ByteBuf p1){ return 0; }
    public static int hashCode(ByteBuf p0){ return 0; }
    public static int indexOf(ByteBuf p0, ByteBuf p1){ return 0; }
    public static int indexOf(ByteBuf p0, int p1, int p2, byte p3){ return 0; }
    public static int reserveAndWriteUtf8(ByteBuf p0, CharSequence p1, int p2){ return 0; }
    public static int reserveAndWriteUtf8(ByteBuf p0, CharSequence p1, int p2, int p3, int p4){ return 0; }
    public static int swapInt(int p0){ return 0; }
    public static int swapMedium(int p0){ return 0; }
    public static int utf8Bytes(CharSequence p0){ return 0; }
    public static int utf8Bytes(CharSequence p0, int p1, int p2){ return 0; }
    public static int utf8MaxBytes(CharSequence p0){ return 0; }
    public static int utf8MaxBytes(int p0){ return 0; }
    public static int writeAscii(ByteBuf p0, CharSequence p1){ return 0; }
    public static int writeUtf8(ByteBuf p0, CharSequence p1){ return 0; }
    public static int writeUtf8(ByteBuf p0, CharSequence p1, int p2, int p3){ return 0; }
    public static long swapLong(long p0){ return 0; }
    public static short swapShort(short p0){ return 0; }
    public static void appendPrettyHexDump(StringBuilder p0, ByteBuf p1){}
    public static void appendPrettyHexDump(StringBuilder p0, ByteBuf p1, int p2, int p3){}
    public static void copy(AsciiString p0, ByteBuf p1){}
    public static void copy(AsciiString p0, int p1, ByteBuf p2, int p3){}
    public static void copy(AsciiString p0, int p1, ByteBuf p2, int p3, int p4){}
}
