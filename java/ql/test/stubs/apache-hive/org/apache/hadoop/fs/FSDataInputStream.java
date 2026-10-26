// Generated automatically from org.apache.hadoop.fs.FSDataInputStream for testing purposes

package org.apache.hadoop.fs;

import java.io.DataInputStream;
import java.io.FileDescriptor;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.EnumSet;
import org.apache.hadoop.fs.ByteBufferReadable;
import org.apache.hadoop.fs.CanSetDropBehind;
import org.apache.hadoop.fs.CanSetReadahead;
import org.apache.hadoop.fs.CanUnbuffer;
import org.apache.hadoop.fs.HasEnhancedByteBufferAccess;
import org.apache.hadoop.fs.HasFileDescriptor;
import org.apache.hadoop.fs.PositionedReadable;
import org.apache.hadoop.fs.ReadOption;
import org.apache.hadoop.fs.Seekable;
import org.apache.hadoop.fs.StreamCapabilities;
import org.apache.hadoop.io.ByteBufferPool;

public class FSDataInputStream extends DataInputStream implements ByteBufferReadable, CanSetDropBehind, CanSetReadahead, CanUnbuffer, HasEnhancedByteBufferAccess, HasFileDescriptor, PositionedReadable, Seekable, StreamCapabilities
{
    protected FSDataInputStream() { super(null); }
    public ByteBuffer read(ByteBufferPool p0, int p1, EnumSet<ReadOption> p2){ return null; }
    public FSDataInputStream(InputStream p0){ super(p0); }
    public FileDescriptor getFileDescriptor(){ return null; }
    public InputStream getWrappedStream(){ return null; }
    public String toString(){ return null; }
    public boolean hasCapability(String p0){ return false; }
    public boolean seekToNewSource(long p0){ return false; }
    public final ByteBuffer read(ByteBufferPool p0, int p1){ return null; }
    public int read(ByteBuffer p0){ return 0; }
    public int read(long p0, byte[] p1, int p2, int p3){ return 0; }
    public long getPos(){ return 0; }
    public void readFully(long p0, byte[] p1){}
    public void readFully(long p0, byte[] p1, int p2, int p3){}
    public void releaseBuffer(ByteBuffer p0){}
    public void seek(long p0){}
    public void setDropBehind(Boolean p0){}
    public void setReadahead(Long p0){}
    public void unbuffer(){}
}
