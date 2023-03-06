// Generated automatically from org.apache.hadoop.fs.FsStatus for testing purposes

package org.apache.hadoop.fs;

import java.io.DataInput;
import java.io.DataOutput;
import org.apache.hadoop.io.Writable;

public class FsStatus implements Writable
{
    protected FsStatus() {}
    public FsStatus(long p0, long p1, long p2){}
    public long getCapacity(){ return 0; }
    public long getRemaining(){ return 0; }
    public long getUsed(){ return 0; }
    public void readFields(DataInput p0){}
    public void write(DataOutput p0){}
}
