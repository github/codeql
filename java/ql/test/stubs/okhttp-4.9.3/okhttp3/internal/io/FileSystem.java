// Generated automatically from okhttp3.internal.io.FileSystem for testing purposes

package okhttp3.internal.io;

import java.io.File;
import okio.Sink;
import okio.Source;

public interface FileSystem
{
    Sink appendingSink(File p0);
    Sink sink(File p0);
    Source source(File p0);
    boolean exists(File p0);
    long size(File p0);
    static FileSystem SYSTEM = null;
    static FileSystem.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
    }
    void delete(File p0);
    void deleteContents(File p0);
    void rename(File p0, File p1);
}
