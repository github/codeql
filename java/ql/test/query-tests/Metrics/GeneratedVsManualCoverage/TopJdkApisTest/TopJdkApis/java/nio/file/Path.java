// Generated automatically from java.nio.file.Path for testing purposes

package java.nio.file;

import java.io.File;
import java.net.URI;
import java.nio.file.FileSystem;
import java.nio.file.LinkOption;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.nio.file.Watchable;
import java.util.Iterator;

public interface Path extends Comparable<Path>, Iterable<Path>, Watchable
{
    File toFile(); // manual summary
    Path getFileName(); // manual summary
    Path getParent(); // manual summary
    Path resolve(String p0); // manual summary
    Path toAbsolutePath(); // manual summary
    String toString(); // manual summary
}
