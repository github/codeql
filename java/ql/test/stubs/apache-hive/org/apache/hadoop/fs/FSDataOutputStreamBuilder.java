// Generated automatically from org.apache.hadoop.fs.FSDataOutputStreamBuilder for testing purposes

package org.apache.hadoop.fs;

import java.util.EnumSet;
import java.util.Set;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.CreateFlag;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Options;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.util.Progressable;

abstract public class FSDataOutputStreamBuilder<S extends FSDataOutputStream, B extends FSDataOutputStreamBuilder<S, B>>
{
    protected FSDataOutputStreamBuilder() {}
    protected Configuration getOptions(){ return null; }
    protected EnumSet<CreateFlag> getFlags(){ return null; }
    protected FSDataOutputStreamBuilder(FileSystem p0, Path p1){}
    protected FileSystem getFS(){ return null; }
    protected FsPermission getPermission(){ return null; }
    protected Options.ChecksumOpt getChecksumOpt(){ return null; }
    protected Path getPath(){ return null; }
    protected Progressable getProgress(){ return null; }
    protected Set<String> getMandatoryKeys(){ return null; }
    protected abstract B getThisBuilder();
    protected boolean isRecursive(){ return false; }
    protected int getBufferSize(){ return 0; }
    protected long getBlockSize(){ return 0; }
    protected short getReplication(){ return 0; }
    public B append(){ return null; }
    public B blockSize(long p0){ return null; }
    public B bufferSize(int p0){ return null; }
    public B checksumOpt(Options.ChecksumOpt p0){ return null; }
    public B create(){ return null; }
    public B must(String p0, String p1){ return null; }
    public B must(String p0, String... p1){ return null; }
    public B must(String p0, boolean p1){ return null; }
    public B must(String p0, double p1){ return null; }
    public B must(String p0, float p1){ return null; }
    public B must(String p0, int p1){ return null; }
    public B opt(String p0, String p1){ return null; }
    public B opt(String p0, String... p1){ return null; }
    public B opt(String p0, boolean p1){ return null; }
    public B opt(String p0, double p1){ return null; }
    public B opt(String p0, float p1){ return null; }
    public B opt(String p0, int p1){ return null; }
    public B overwrite(boolean p0){ return null; }
    public B permission(FsPermission p0){ return null; }
    public B progress(Progressable p0){ return null; }
    public B recursive(){ return null; }
    public B replication(short p0){ return null; }
    public abstract S build();
}
