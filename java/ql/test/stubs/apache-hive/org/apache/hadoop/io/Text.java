// Generated automatically from org.apache.hadoop.io.Text for testing purposes

package org.apache.hadoop.io;

import java.io.DataInput;
import java.io.DataOutput;
import java.nio.ByteBuffer;
import org.apache.hadoop.io.BinaryComparable;
import org.apache.hadoop.io.WritableComparable;

public class Text extends BinaryComparable implements WritableComparable<BinaryComparable>
{
    public String toString(){ return null; }
    public Text(){}
    public Text(String p0){}
    public Text(Text p0){}
    public Text(byte[] p0){}
    public boolean equals(Object p0){ return false; }
    public byte[] copyBytes(){ return null; }
    public byte[] getBytes(){ return null; }
    public int charAt(int p0){ return 0; }
    public int find(String p0){ return 0; }
    public int find(String p0, int p1){ return 0; }
    public int getLength(){ return 0; }
    public int hashCode(){ return 0; }
    public static ByteBuffer encode(String p0){ return null; }
    public static ByteBuffer encode(String p0, boolean p1){ return null; }
    public static String decode(byte[] p0){ return null; }
    public static String decode(byte[] p0, int p1, int p2){ return null; }
    public static String decode(byte[] p0, int p1, int p2, boolean p3){ return null; }
    public static String readString(DataInput p0){ return null; }
    public static String readString(DataInput p0, int p1){ return null; }
    public static int DEFAULT_MAX_LEN = 0;
    public static int bytesToCodePoint(ByteBuffer p0){ return 0; }
    public static int utf8Length(String p0){ return 0; }
    public static int writeString(DataOutput p0, String p1){ return 0; }
    public static int writeString(DataOutput p0, String p1, int p2){ return 0; }
    public static void skip(DataInput p0){}
    public static void validateUTF8(byte[] p0){}
    public static void validateUTF8(byte[] p0, int p1, int p2){}
    public void append(byte[] p0, int p1, int p2){}
    public void clear(){}
    public void readFields(DataInput p0){}
    public void readFields(DataInput p0, int p1){}
    public void readWithKnownLength(DataInput p0, int p1){}
    public void set(String p0){}
    public void set(Text p0){}
    public void set(byte[] p0){}
    public void set(byte[] p0, int p1, int p2){}
    public void write(DataOutput p0){}
    public void write(DataOutput p0, int p1){}
}
