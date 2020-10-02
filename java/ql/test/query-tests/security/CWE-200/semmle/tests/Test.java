
import java.io.File;
import com.google.common.io.Files;

public class Test {

    void vulnerableFileCreateTempFile() {
        File temp = File.createTempFile("random", "file");
    }

    void vulnerableFileCreateTempFileNull() {
        File temp = File.createTempFile("random", "file", null);
    }

    void vulnerableFileCreateTempFileTainted() {
        File tempDir = new File(System.getProperty("java.io.tmpdir"));
        File temp = File.createTempFile("random", "file", tempDir);
    }

    void vulnerableFileCreateTempFileChildTainted() {
        File tempDirChild = new File(new File(System.getProperty("java.io.tmpdir")), "/child");
        File temp = File.createTempFile("random", "file", tempDirChild);
    }

    void vulnerableFileCreateTempFileCanonical() {
        File tempDir = new File(System.getProperty("java.io.tmpdir")).getCanonicalFile();
        File temp = File.createTempFile("random", "file", tempDir);
    }

    void vulnerableFileCreateTempFileAbsolute() {
        File tempDir = new File(System.getProperty("java.io.tmpdir")).getAbsoluteFile();
        File temp = File.createTempFile("random", "file", tempDir);
    }

    void safeFileCreateTempFileTainted() {
        /* Creating a temporary directoy in the current user directory is not a vulnerability. */
        File currentDirectory = new File(System.getProperty("user.dir"));
        File temp = File.createTempFile("random", "file", currentDirectory);
    }

    void vulnerableGuavaFilesCreateTempDir() {
        File tempDir = Files.createTempDir();
    }

    void vulnerableFileCreateTempFileMkdirTainted() {
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child");
        tempDirChild.mkdir();
    }
    
}
