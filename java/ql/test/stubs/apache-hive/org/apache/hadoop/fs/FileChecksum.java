// Generated automatically from org.apache.hadoop.fs.FileChecksum for testing purposes

package org.apache.hadoop.fs;

import org.apache.hadoop.fs.Options;
import org.apache.hadoop.io.Writable;

abstract public class FileChecksum implements Writable
{
    public FileChecksum(){}
    public Options.ChecksumOpt getChecksumOpt(){ return null; }
    public abstract String getAlgorithmName();
    public abstract byte[] getBytes();
    public abstract int getLength();
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
}
