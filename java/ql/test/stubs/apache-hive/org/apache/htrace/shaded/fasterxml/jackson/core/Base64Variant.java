// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.Base64Variant for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;

import java.io.Serializable;
import org.apache.htrace.shaded.fasterxml.jackson.core.util.ByteArrayBuilder;

public class Base64Variant implements Serializable
{
    protected Base64Variant() {}
    protected Object readResolve(){ return null; }
    protected final String _name = null;
    protected final boolean _usesPadding = false;
    protected final char _paddingChar = '0';
    protected final int _maxLineLength = 0;
    protected void _reportBase64EOF(){}
    protected void _reportInvalidBase64(char p0, int p1, String p2){}
    public Base64Variant(Base64Variant p0, String p1, boolean p2, char p3, int p4){}
    public Base64Variant(Base64Variant p0, String p1, int p2){}
    public Base64Variant(String p0, String p1, boolean p2, char p3, int p4){}
    public String encode(byte[] p0){ return null; }
    public String encode(byte[] p0, boolean p1){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean usesPadding(){ return false; }
    public boolean usesPaddingChar(char p0){ return false; }
    public boolean usesPaddingChar(int p0){ return false; }
    public byte encodeBase64BitsAsByte(int p0){ return 0; }
    public byte getPaddingByte(){ return 0; }
    public byte[] decode(String p0){ return null; }
    public char encodeBase64BitsAsChar(int p0){ return '0'; }
    public char getPaddingChar(){ return '0'; }
    public int decodeBase64Byte(byte p0){ return 0; }
    public int decodeBase64Char(char p0){ return 0; }
    public int decodeBase64Char(int p0){ return 0; }
    public int encodeBase64Chunk(int p0, byte[] p1, int p2){ return 0; }
    public int encodeBase64Chunk(int p0, char[] p1, int p2){ return 0; }
    public int encodeBase64Partial(int p0, int p1, byte[] p2, int p3){ return 0; }
    public int encodeBase64Partial(int p0, int p1, char[] p2, int p3){ return 0; }
    public int getMaxLineLength(){ return 0; }
    public int hashCode(){ return 0; }
    public static int BASE64_VALUE_INVALID = 0;
    public static int BASE64_VALUE_PADDING = 0;
    public void decode(String p0, ByteArrayBuilder p1){}
    public void encodeBase64Chunk(StringBuilder p0, int p1){}
    public void encodeBase64Partial(StringBuilder p0, int p1, int p2){}
}
