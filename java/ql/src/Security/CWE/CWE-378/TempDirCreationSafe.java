import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class TempDirCreationSafe {
    File exampleSafeTemporaryDirectoryCreation() {
        // Best option!
        Path tempDir =
            Files.createTempDirectory("temporary-stuff"); // GOOD! - Files.createTempDirectory creates a temporary directory with safe permissions.
        return tempDir.toFile();
    }
}
