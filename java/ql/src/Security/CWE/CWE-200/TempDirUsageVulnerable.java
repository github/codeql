import java.io.File;

public class TempDirUsageVulnerable {
    void exampleVulnerable() {
        File temp1 = File.createTempFile("random", ".txt"); // BAD: File has permissions `-rw-r--r--`

        File temp2 = File.createTempFile("random", "file", null); // BAD: File has permissions `-rw-r--r--`

        File systemTempDir = new File(System.getProperty("java.io.tmpdir"));
        File temp3 = File.createTempFile("random", "file", systemTempDir); // BAD: File has permissions `-rw-r--r--`

        File tempDir = com.google.common.io.Files.createTempDir(); // BAD: CVE-2020-8908: Directory has permissions `drwxr-xr-x`

        new File(System.getProperty("java.io.tmpdir"), "/child").mkdir(); // BAD: Directory has permissions `-rw-r--r--`

        File tempDirChildFile = new File(System.getProperty("java.io.tmpdir"), "/child-create-file.txt");
        Files.createFile(tempDirChildFile.toPath()); // BAD: File has permissions `-rw-r--r--`

        File tempDirChildDir = new File(System.getProperty("java.io.tmpdir"), "/child-dir");
        tempDirChildDir.mkdir(); // BAD: Directory has permissions `drwxr-xr-x`
        Files.createDirectory(tempDirChildDir.toPath()); // BAD: Directory has permissions `drwxr-xr-x`
    }
}
