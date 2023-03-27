// Generated automatically from io.netty.channel.DefaultFileRegion for testing purposes

package io.netty.channel;

import io.netty.channel.FileRegion;
import io.netty.util.AbstractReferenceCounted;
import java.io.File;
import java.nio.channels.FileChannel;
import java.nio.channels.WritableByteChannel;

public class DefaultFileRegion extends AbstractReferenceCounted implements FileRegion
{
    protected DefaultFileRegion() {}
    protected void deallocate(){}
    public DefaultFileRegion(File p0, long p1, long p2){}
    public DefaultFileRegion(FileChannel p0, long p1, long p2){}
    public FileRegion retain(){ return null; }
    public FileRegion retain(int p0){ return null; }
    public FileRegion touch(){ return null; }
    public FileRegion touch(Object p0){ return null; }
    public boolean isOpen(){ return false; }
    public long count(){ return 0; }
    public long position(){ return 0; }
    public long transferTo(WritableByteChannel p0, long p1){ return 0; }
    public long transfered(){ return 0; }
    public long transferred(){ return 0; }
    public void open(){}
}
