// Generated automatically from org.apache.sshd.common.compression.Compression for testing purposes

package org.apache.sshd.common.compression;

import org.apache.sshd.common.compression.CompressionInformation;
import org.apache.sshd.common.util.buffer.Buffer;

public interface Compression extends CompressionInformation
{
    static public enum Type
    {
        Deflater, Inflater;
        private Type() {}
    }
    void compress(Buffer p0);
    void init(Compression.Type p0, int p1);
    void uncompress(Buffer p0, Buffer p1);
}
