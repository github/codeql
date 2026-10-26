// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.SerializableString for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;

import java.io.OutputStream;
import java.nio.ByteBuffer;

public interface SerializableString
{
    String getValue();
    byte[] asQuotedUTF8();
    byte[] asUnquotedUTF8();
    char[] asQuotedChars();
    int appendQuoted(char[] p0, int p1);
    int appendQuotedUTF8(byte[] p0, int p1);
    int appendUnquoted(char[] p0, int p1);
    int appendUnquotedUTF8(byte[] p0, int p1);
    int charLength();
    int putQuotedUTF8(ByteBuffer p0);
    int putUnquotedUTF8(ByteBuffer p0);
    int writeQuotedUTF8(OutputStream p0);
    int writeUnquotedUTF8(OutputStream p0);
}
