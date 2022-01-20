import java.io.File;
import java.io.IOException;

public class TempDirCreationVulnerable {
    File exampleVulnerableTemporaryDirectoryCreation() throws IOException {
        File temp = File.createTempFile("temporary", "stuff"); // Attacker knows the full path of the directory that will be generated.
        // delete the file that was created
        temp.delete(); // Attacker sees file is deleted and begins a race to create their own directory with wide file permissions.
        // and make a directory of the same name.
        // SECURITY VULNERABILITY: Race Condition! - If the attacker beats your application to directory creation they will own this directory.
        temp.mkdir(); // BAD! Race condition
        return temp;
    }
}
