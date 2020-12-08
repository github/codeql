
import java.util.Arrays;
import java.io.File;
import java.nio.file.Files;
import java.nio.charset.StandardCharsets;
import java.nio.file.StandardOpenOption;

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
        File tempDir = com.google.common.io.Files.createTempDir();
    }

    void vulnerableFileCreateTempFileMkdirTainted() {
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child");
        tempDirChild.mkdir();
    }

    void vulnerableFileCreateTempFileMkdirsTainted() {
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child");
        tempDirChild.mkdir();
    }

    void vulnerableFileCreateTempFilesWrite1() {
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child");
        Files.write(tempDirChild.toPath(), Arrays.asList("secret"), StandardCharsets.UTF_8, StandardOpenOption.CREATE);
    }
    
    void vulnerableFileCreateTempFilesWrite2() {
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child");
        String secret = "secret";
        byte[] byteArrray = secret.getBytes();
        Files.write(tempDirChild.toPath(), byteArrray, StandardOpenOption.CREATE);
    }
}
