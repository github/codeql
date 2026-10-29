// Generated automatically from okhttp3.internal.cache.DiskLruCache for testing purposes

package okhttp3.internal.cache;

import java.io.Closeable;
import java.io.File;
import java.io.Flushable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import kotlin.text.Regex;
import okhttp3.internal.concurrent.TaskRunner;
import okhttp3.internal.io.FileSystem;
import okio.BufferedSink;
import okio.Sink;
import okio.Source;

public class DiskLruCache implements Closeable, Flushable
{
    protected DiskLruCache() {}
    public DiskLruCache(FileSystem p0, File p1, int p2, int p3, long p4, TaskRunner p5){}
    public class Editor
    {
        protected Editor() {}
        public Editor(DiskLruCache.Entry p0){}
        public final DiskLruCache.Entry getEntry$okhttp(){ return null; }
        public final Sink newSink(int p0){ return null; }
        public final Source newSource(int p0){ return null; }
        public final boolean[] getWritten$okhttp(){ return null; }
        public final void abort(){}
        public final void commit(){}
        public final void detach$okhttp(){}
    }
    public class Entry
    {
        protected Entry() {}
        public Entry(String p0){}
        public final DiskLruCache.Editor getCurrentEditor$okhttp(){ return null; }
        public final DiskLruCache.Snapshot snapshot$okhttp(){ return null; }
        public final List<File> getCleanFiles$okhttp(){ return null; }
        public final List<File> getDirtyFiles$okhttp(){ return null; }
        public final String getKey$okhttp(){ return null; }
        public final boolean getReadable$okhttp(){ return false; }
        public final boolean getZombie$okhttp(){ return false; }
        public final int getLockingSourceCount$okhttp(){ return 0; }
        public final long getSequenceNumber$okhttp(){ return 0; }
        public final long[] getLengths$okhttp(){ return null; }
        public final void setCurrentEditor$okhttp(DiskLruCache.Editor p0){}
        public final void setLengths$okhttp(List<String> p0){}
        public final void setLockingSourceCount$okhttp(int p0){}
        public final void setReadable$okhttp(boolean p0){}
        public final void setSequenceNumber$okhttp(long p0){}
        public final void setZombie$okhttp(boolean p0){}
        public final void writeLengths$okhttp(BufferedSink p0){}
    }
    public class Snapshot implements Closeable
    {
        protected Snapshot() {}
        public Snapshot(String p0, long p1, List<? extends Source> p2, long[] p3){}
        public final DiskLruCache.Editor edit(){ return null; }
        public final Source getSource(int p0){ return null; }
        public final String key(){ return null; }
        public final long getLength(int p0){ return 0; }
        public void close(){}
    }
    public final DiskLruCache.Editor edit(String p0){ return null; }
    public final DiskLruCache.Editor edit(String p0, long p1){ return null; }
    public final DiskLruCache.Snapshot get(String p0){ return null; }
    public final File getDirectory(){ return null; }
    public final FileSystem getFileSystem$okhttp(){ return null; }
    public final Iterator<DiskLruCache.Snapshot> snapshots(){ return null; }
    public final LinkedHashMap<String, DiskLruCache.Entry> getLruEntries$okhttp(){ return null; }
    public final boolean getClosed$okhttp(){ return false; }
    public final boolean isClosed(){ return false; }
    public final boolean remove(String p0){ return false; }
    public final boolean removeEntry$okhttp(DiskLruCache.Entry p0){ return false; }
    public final int getValueCount$okhttp(){ return 0; }
    public final long getMaxSize(){ return 0; }
    public final long size(){ return 0; }
    public final void completeEdit$okhttp(DiskLruCache.Editor p0, boolean p1){}
    public final void delete(){}
    public final void evictAll(){}
    public final void initialize(){}
    public final void rebuildJournal$okhttp(){}
    public final void setClosed$okhttp(boolean p0){}
    public final void setMaxSize(long p0){}
    public final void trimToSize(){}
    public static DiskLruCache.Companion Companion = null;
    public static Regex LEGAL_KEY_PATTERN = null;
    public static String CLEAN = null;
    public static String DIRTY = null;
    public static String JOURNAL_FILE = null;
    public static String JOURNAL_FILE_BACKUP = null;
    public static String JOURNAL_FILE_TEMP = null;
    public static String MAGIC = null;
    public static String READ = null;
    public static String REMOVE = null;
    public static String VERSION_1 = null;
    public static long ANY_SEQUENCE_NUMBER = 0;
    public void close(){}
    public void flush(){}
    static public class Companion
    {
        protected Companion() {}
    }
}
