// Generated automatically from org.apache.hadoop.util.DataChecksum for testing purposes

package org.apache.hadoop.util;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.nio.ByteBuffer;
import java.util.zip.Checksum;

public class DataChecksum implements Checksum
{
    protected DataChecksum() {}
    public DataChecksum.Type getChecksumType(){ return null; }
    public String toString(){ return null; }
    public boolean compare(byte[] p0, int p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public byte[] getHeader(){ return null; }
    public int getBytesPerChecksum(){ return 0; }
    public int getChecksumSize(){ return 0; }
    public int getChecksumSize(int p0){ return 0; }
    public int getNumBytesInSum(){ return 0; }
    public int hashCode(){ return 0; }
    public int writeValue(DataOutputStream p0, boolean p1){ return 0; }
    public int writeValue(byte[] p0, int p1, boolean p2){ return 0; }
    public long getValue(){ return 0; }
    public static Checksum newCrc32(){ return null; }
    public static DataChecksum newDataChecksum(DataChecksum.Type p0, int p1){ return null; }
    public static DataChecksum newDataChecksum(DataInputStream p0){ return null; }
    public static DataChecksum newDataChecksum(byte[] p0, int p1){ return null; }
    public static int CHECKSUM_CRC32 = 0;
    public static int CHECKSUM_CRC32C = 0;
    public static int CHECKSUM_DEFAULT = 0;
    public static int CHECKSUM_MIXED = 0;
    public static int CHECKSUM_NULL = 0;
    public static int SIZE_OF_INTEGER = 0;
    public static int getChecksumHeaderSize(){ return 0; }
    public void calculateChunkedSums(ByteBuffer p0, ByteBuffer p1){}
    public void calculateChunkedSums(byte[] p0, int p1, int p2, byte[] p3, int p4){}
    public void reset(){}
    public void update(byte[] p0, int p1, int p2){}
    public void update(int p0){}
    public void verifyChunkedSums(ByteBuffer p0, ByteBuffer p1, String p2, long p3){}
    public void writeHeader(DataOutputStream p0){}
    static public enum Type
    {
        CRC32, CRC32C, DEFAULT, MIXED, NULL;
        private Type() {}
        public final int id = 0;
        public final int size = 0;
    }
}
