// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.io.SerializedString for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core.io;

import java.io.OutputStream;
import java.io.Serializable;
import java.nio.ByteBuffer;
import org.apache.htrace.shaded.fasterxml.jackson.core.SerializableString;

public class SerializedString implements Serializable, SerializableString
{
    protected SerializedString() {}
    protected Object readResolve(){ return null; }
    protected String _jdkSerializeValue = null;
    protected byte[] _quotedUTF8Ref = null;
    protected byte[] _unquotedUTF8Ref = null;
    protected char[] _quotedChars = null;
    protected final String _value = null;
    public SerializedString(String p0){}
    public final String getValue(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final byte[] asQuotedUTF8(){ return null; }
    public final byte[] asUnquotedUTF8(){ return null; }
    public final char[] asQuotedChars(){ return null; }
    public final int charLength(){ return 0; }
    public final int hashCode(){ return 0; }
    public int appendQuoted(char[] p0, int p1){ return 0; }
    public int appendQuotedUTF8(byte[] p0, int p1){ return 0; }
    public int appendUnquoted(char[] p0, int p1){ return 0; }
    public int appendUnquotedUTF8(byte[] p0, int p1){ return 0; }
    public int putQuotedUTF8(ByteBuffer p0){ return 0; }
    public int putUnquotedUTF8(ByteBuffer p0){ return 0; }
    public int writeQuotedUTF8(OutputStream p0){ return 0; }
    public int writeUnquotedUTF8(OutputStream p0){ return 0; }
}
