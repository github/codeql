import java.io.File;
import java.nio.file.Files;
import java.nio.file.spi.FileSystemProvider;
import java.nio.file.LinkOption;
import java.text.Collator;
import java.text.RuleBasedCollator;
import java.util.prefs.AbstractPreferences;
import java.util.prefs.Preferences;
import org.apache.hc.client5.http.protocol.RedirectLocations;

public class Test {

    public void test() throws Exception {

        // java.io
        File file = null;
        file.exists(); // Neutral Sink
        file.compareTo(null); // Neutral Sink

        // java.nio.file
        Files.exists(null, (LinkOption[])null); // Neutral Sink
        Files.getLastModifiedTime(null, (LinkOption[])null); // Neutral Sink
        Files.getOwner(null, (LinkOption[])null); // Neutral Sink
        Files.getPosixFilePermissions(null, (LinkOption[])null); // Neutral Sink
        Files.isDirectory(null, (LinkOption[])null); // Neutral Sink
        Files.isExecutable(null); // Neutral Sink
        Files.isHidden(null); // Neutral Sink
        Files.isReadable(null); // Neutral Sink
        Files.isRegularFile(null, (LinkOption[])null); // Neutral Sink
        Files.isSameFile(null, null); // Neutral Sink
        Files.isSymbolicLink(null); // Neutral Sink
        Files.isWritable(null); // Neutral Sink
        Files.notExists(null, (LinkOption[])null); // Neutral Sink
        Files.setLastModifiedTime(null, null); // Neutral Sink
        Files.size(null); // Neutral Sink

        // java.nio.file.spi
        FileSystemProvider fsp = null;
        fsp.isHidden(null); // Neutral Sink
        fsp.isSameFile(null, null); // Neutral Sink

        // java.text
        Collator c = null;
        c.compare(null, null); // Neutral Sink
        c.equals(null); // Neutral Sink
        c.equals(null, null); // Neutral Sink
        RuleBasedCollator rbc = null;
        rbc.compare(null, null); // Neutral Sink

        // java.util.prefs
        AbstractPreferences ap = null;
        ap.nodeExists(null); // Neutral Sink
        Preferences p = null;
        p.nodeExists(null); // Neutral Sink

        // org.apache.hc.client5.http.protocol
        RedirectLocations rl = null;
        rl.contains(null); // Neutral Sink
    }

}
