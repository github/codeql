// Generated automatically from org.apache.commons.compress.archivers.ArchiveInputStream for testing purposes

package org.apache.commons.compress.archivers;

import java.io.InputStream;
import org.apache.commons.compress.archivers.ArchiveEntry;

abstract public class ArchiveInputStream extends InputStream
{
    protected void count(int p0){}
    protected void count(long p0){}
    protected void pushedBackBytes(long p0){}
    public ArchiveInputStream(){}
    public abstract ArchiveEntry getNextEntry();
    public boolean canReadEntryData(ArchiveEntry p0){ return false; }
    public int getCount(){ return 0; }
    public int read(){ return 0; }
    public long getBytesRead(){ return 0; }
}
