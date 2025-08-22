// Generated automatically from org.springframework.util.StreamUtils for testing purposes

package org.springframework.util;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;

abstract public class StreamUtils
{
    public StreamUtils(){}
    public static InputStream emptyInput(){ return null; }
    public static InputStream nonClosing(InputStream p0){ return null; }
    public static OutputStream nonClosing(OutputStream p0){ return null; }
    public static String copyToString(ByteArrayOutputStream p0, Charset p1){ return null; }
    public static String copyToString(InputStream p0, Charset p1){ return null; }
    public static byte[] copyToByteArray(InputStream p0){ return null; }
    public static int BUFFER_SIZE = 0;
    public static int copy(InputStream p0, OutputStream p1){ return 0; }
    public static int drain(InputStream p0){ return 0; }
    public static long copyRange(InputStream p0, OutputStream p1, long p2, long p3){ return 0; }
    public static void copy(String p0, Charset p1, OutputStream p2){}
    public static void copy(byte[] p0, OutputStream p1){}
}
