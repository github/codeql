import java.nio.file.Files;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.EnumSet;

public class TempDirUsageSafe {
    void exampleSafe() throws IOException {
        Path temp1 = Files.createTempFile("random", ".txt"); // GOOD: File has permissions `-rw-------`

        Path temp2 = Files.createTempDirectory("random-directory"); // GOOD: File has permissions `drwx------`

        File tempDirChildFile = new File(System.getProperty("java.io.tmpdir"), "/child-create-file.txt");
        Files.createFile(
            tempDirChildFile.toPath(),
            tempDirChild.toPath(),
            PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE))
        ); // GOOD: Good has permissions `-rw-------`
    }
}
