// Generated automatically from org.apache.hadoop.fs.FsServerDefaults for testing purposes

package org.apache.hadoop.fs;

import java.io.DataInput;
import java.io.DataOutput;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.util.DataChecksum;

public class FsServerDefaults implements Writable
{
    public DataChecksum.Type getChecksumType(){ return null; }
    public FsServerDefaults(){}
    public FsServerDefaults(long p0, int p1, int p2, short p3, int p4, boolean p5, long p6, DataChecksum.Type p7){}
    public FsServerDefaults(long p0, int p1, int p2, short p3, int p4, boolean p5, long p6, DataChecksum.Type p7, String p8){}
    public FsServerDefaults(long p0, int p1, int p2, short p3, int p4, boolean p5, long p6, DataChecksum.Type p7, String p8, byte p9){}
    public String getKeyProviderUri(){ return null; }
    public boolean getEncryptDataTransfer(){ return false; }
    public byte getDefaultStoragePolicyId(){ return 0; }
    public int getBytesPerChecksum(){ return 0; }
    public int getFileBufferSize(){ return 0; }
    public int getWritePacketSize(){ return 0; }
    public long getBlockSize(){ return 0; }
    public long getTrashInterval(){ return 0; }
    public short getReplication(){ return 0; }
    public void readFields(DataInput p0){}
    public void write(DataOutput p0){}
}
