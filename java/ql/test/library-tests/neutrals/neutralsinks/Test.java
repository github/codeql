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
        file.compareTo(null); // $ isNeutralSink

        // java.nio.file
        Files.getLastModifiedTime(null, (LinkOption[])null); // $ isNeutralSink
        Files.getOwner(null, (LinkOption[])null); // $ isNeutralSink
        Files.getPosixFilePermissions(null, (LinkOption[])null); // $ isNeutralSink
        Files.isDirectory(null, (LinkOption[])null); // $ isNeutralSink
        Files.isExecutable(null); // $ isNeutralSink
        Files.isHidden(null); // $ isNeutralSink
        Files.isReadable(null); // $ isNeutralSink
        Files.isRegularFile(null, (LinkOption[])null); // $ isNeutralSink
        Files.isSameFile(null, null); // $ isNeutralSink
        Files.isSymbolicLink(null); // $ isNeutralSink
        Files.isWritable(null); // $ isNeutralSink
        Files.setLastModifiedTime(null, null); // $ isNeutralSink
        Files.size(null); // $ isNeutralSink

        // java.nio.file.spi
        FileSystemProvider fsp = null;
        fsp.isHidden(null); // $ isNeutralSink
        fsp.isSameFile(null, null); // $ isNeutralSink

        // java.text
        Collator c = null;
        c.compare(null, null); // $ isNeutralSink
        c.equals(null); // $ isNeutralSink
        c.equals(null, null); // $ isNeutralSink
        RuleBasedCollator rbc = null;
        rbc.compare(null, null); // $ isNeutralSink

        // java.util.prefs
        AbstractPreferences ap = null;
        ap.nodeExists(null); // $ isNeutralSink
        Preferences p = null;
        p.nodeExists(null); // $ isNeutralSink

        // org.apache.hc.client5.http.protocol
        RedirectLocations rl = null;
        rl.contains(null); // $ isNeutralSink
    }

}
