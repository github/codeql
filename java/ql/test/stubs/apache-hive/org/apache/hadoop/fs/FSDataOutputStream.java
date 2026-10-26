// Generated automatically from org.apache.hadoop.fs.FSDataOutputStream for testing purposes

package org.apache.hadoop.fs;

import java.io.DataOutputStream;
import java.io.OutputStream;
import org.apache.hadoop.fs.CanSetDropBehind;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.StreamCapabilities;
import org.apache.hadoop.fs.Syncable;

public class FSDataOutputStream extends DataOutputStream
        implements CanSetDropBehind, StreamCapabilities, Syncable {
    protected FSDataOutputStream() {
        super(null);
    }

    public FSDataOutputStream(OutputStream p0, FileSystem.Statistics p1) {
        super(p0);
    }

    public FSDataOutputStream(OutputStream p0, FileSystem.Statistics p1, long p2) {
        super(p0);
    }

    public OutputStream getWrappedStream() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean hasCapability(String p0) {
        return false;
    }

    public long getPos() {
        return 0;
    }

    public void close() {}

    public void hflush() {}

    public void hsync() {}

    public void setDropBehind(Boolean p0) {}
}
