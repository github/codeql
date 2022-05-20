
import java.util.Arrays;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.EnumSet;

import org.apache.commons.lang3.SystemUtils;

public class Test {

    void vulnerableFileCreateTempFile() throws IOException {
        // VULNERABLE VERSION:
        File tempVuln = File.createTempFile("random", "file");

        // TO MAKE SAFE REWRITE TO:
        File tempSafe = Files.createTempFile("random", "file").toFile();
    }

    void vulnerableFileCreateTempFileNull() throws IOException {
        // VULNERABLE VERSION:
        File tempVuln = File.createTempFile("random", "file", null);

        // TO MAKE SAFE REWRITE TO:
        File tempSafe = Files.createTempFile("random", "file").toFile();
    }

    void vulnerableFileCreateTempFileTainted() throws IOException {
        // GIVEN:
        File tempDir = new File(System.getProperty("java.io.tmpdir"));

        // VULNERABLE VERSION:
        File tempVuln = File.createTempFile("random", "file", tempDir);

        // TO MAKE SAFE REWRITE TO (v1):
        File tempSafe1 = Files.createTempFile(tempDir.toPath(), "random", "file").toFile();

        // TO MAKE SAFE REWRITE TO (v2):
        File tempSafe2 = Files.createTempFile("random", "file").toFile();
    }

    void vulnerableFileCreateTempFileChildTainted() throws IOException {
        // GIVEN:
        File tempDirChild = new File(new File(System.getProperty("java.io.tmpdir")), "/child");

        // VULNERABLE VERSION:
        File tempVuln = File.createTempFile("random", "file", tempDirChild);

        // TO MAKE SAFE REWRITE TO:
        File tempSafe = Files.createTempFile(tempDirChild.toPath(), "random", "file").toFile();
    }

    void vulnerableFileCreateTempFileCanonical() throws IOException {
        // GIVEN:
        File tempDir = new File(System.getProperty("java.io.tmpdir")).getCanonicalFile();

        // VULNERABLE VERSION:
        File tempVuln = File.createTempFile("random", "file", tempDir);

        // TO MAKE SAFE REWRITE TO (v1):
        File tempSafe1 = Files.createTempFile(tempDir.toPath(), "random", "file").toFile();

        // TO MAKE SAFE REWRITE TO (v2):
        File tempSafe2 = Files.createTempFile("random", "file").toFile();
    }

    void vulnerableFileCreateTempFileAbsolute() throws IOException {
        // GIVEN:
        File tempDir = new File(System.getProperty("java.io.tmpdir")).getAbsoluteFile();

        // VULNERABLE VERSION:
        File tempVuln = File.createTempFile("random", "file", tempDir);

        // TO MAKE SAFE REWRITE TO (v1):
        File tempSafe1 = Files.createTempFile(tempDir.toPath(), "random", "file").toFile();
        // TO MAKE SAFE REWRITE TO (v2):
        File tempSafe2 = Files.createTempFile("random", "file").toFile();
    }

    void safeFileCreateTempFileTainted() throws IOException {
        /*
         * Creating a temporary directoy in the current user directory is not a
         * vulnerability.
         */
        File currentDirectory = new File(System.getProperty("user.dir"));
        File temp = File.createTempFile("random", "file", currentDirectory);
    }

    void vulnerableGuavaFilesCreateTempDir() {
        // VULNERABLE VERSION:
        File tempDir = com.google.common.io.Files.createTempDir();

        // TO MAKE SAFE REWRITE TO:
        File tempSafe;
        try {
            Files.createTempDirectory("random").toFile();
        } catch (IOException e) {
            throw new RuntimeException("Failed to create temporary directory", e);
        }
    }

    void vulnerableFileCreateTempFileMkdirTainted() {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child");

        // VULNERABLE VERSION:
        tempDirChild.mkdir();

        // TO MAKE SAFE REWRITE TO (v1):
        File tempSafe1;
        try {
            tempSafe1 = Files.createTempDirectory(tempDirChild.toPath(), "random").toFile();
        } catch (IOException e) {
            throw new RuntimeException("Failed to create temporary directory", e);
        }

        // TO MAKE SAFE REWRITE TO (v2):
        File tempSafe2;
        try {
            tempSafe2 = Files.createTempDirectory("random").toFile();
        } catch (IOException e) {
            throw new RuntimeException("Failed to create temporary directory", e);
        }
    }

    void vulnerableFileCreateTempFileMkdirsTainted() {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child");
        
        // VULNERABLE VERSION:
        tempDirChild.mkdirs();

        // TO MAKE SAFE REWRITE TO (v1):
        File tempSafe1;
        try {
            tempSafe1 = Files.createTempDirectory(tempDirChild.toPath(), "random").toFile();
        } catch (IOException e) {
            throw new RuntimeException("Failed to create temporary directory", e);
        }

        // TO MAKE SAFE REWRITE TO (v2):
        File tempSafe2;
        try {
            tempSafe2 = Files.createTempDirectory("random").toFile();
        } catch (IOException e) {
            throw new RuntimeException("Failed to create temporary directory", e);
        }
    }

    void vulnerableFileCreateTempFilesWrite1() throws IOException {
        // VULNERABLE VERSION:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child.txt");
        Files.write(tempDirChild.toPath(), Arrays.asList("secret"), StandardCharsets.UTF_8, StandardOpenOption.CREATE);

        // TO MAKE SAFE REWRITE TO (v1):
        // Use this version if you care that the file has the exact path of `[java.io.tmpdir]/child.txt`
        try {
            Path tempSafe = Paths.get(System.getProperty("java.io.tmpdir"), "child.txt");
            Files.createFile(tempSafe, PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
            Files.write(tempSafe, Arrays.asList("secret"));
        } catch (IOException e) {
            throw new RuntimeException("Failed to write temporary file", e);
        }

        // TO MAKE SAFE REWRITE TO (v2):
        // Use this version if you don't care that the file has an exact path. This will write to a file of the name `[java.io.tmpdir]/random[random string]child.txt`
        try {
            Path tempSafe = Files.createTempFile("random", "child.txt");
            Files.write(tempSafe, Arrays.asList("secret"), StandardCharsets.UTF_8, StandardOpenOption.CREATE);
        } catch (IOException e) {
            throw new RuntimeException("Failed to write temporary file", e);
        }
    }

    void vulnerableFileCreateTempFilesWrite2() throws IOException {
        // GIVEN:
        String secret = "secret";
        byte[] byteArrray = secret.getBytes();
        
        // VULNERABLE VERSION:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child.txt");
        Files.write(tempDirChild.toPath(), byteArrray, StandardOpenOption.CREATE);
        
        // TO MAKE SAFE REWRITE TO (v1):
        // Use this version if you care that the file has the exact path of `[java.io.tmpdir]/child.txt`
        Path tempSafe1 = Paths.get(System.getProperty("java.io.tmpdir"), "child.txt");
        Files.createFile(tempSafe1, PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
        Files.write(tempSafe1, byteArrray);

        // TO MAKE SAFE REWRITE TO (v2):
        // Use this version if you don't care that the file has an exact path. This will write to a file of the name `[java.io.tmpdir]/random[random string]child.txt`
        Path tempSafe2 = Files.createTempFile("random", "child.txt");
        Files.write(tempSafe2, byteArrray);
    }

    void vulnerableFileCreateTempFilesNewBufferedWriter() throws IOException {
        // GIVEN:
        Path tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-buffered-writer.txt").toPath();
        
        // VULNERABLE VERSION:
        Files.newBufferedWriter(tempDirChild);

        // TO MAKE SAFE REWRITE TO:
        Files.createFile(tempDirChild, PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
        Files.newBufferedWriter(tempDirChild);
    }

    void vulnerableFileCreateTempFilesNewOutputStream() throws IOException {
        // GIVEN:
        Path tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-output-stream.txt").toPath();
        
        // VULNERABLE VERSION:
        Files.newOutputStream(tempDirChild).close();

        // TO MAKE SAFE REWRITE TO:
        Files.createFile(tempDirChild, PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
        Files.newOutputStream(tempDirChild).close();
    }

    void vulnerableFileCreateTempFilesCreateFile() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-file.txt");
        
        // VULNERABLE VERSION:
        Files.createFile(tempDirChild.toPath());

        // TO MAKE SAFE REWRITE TO:
        Files.createFile(tempDirChild.toPath(), PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
    }

    void safeFileCreateTempFilesCreateFile() throws IOException {
        // Clear permissions intentions by setting the 'OWNER_READ' and 'OWNER_WRITE'
        // permissions.
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-file.txt");
        Files.createFile(
                tempDirChild.toPath(),
                PosixFilePermissions
                        .asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
    }

    void vulnerableFileCreateDirectory() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        // VULNERABLE VERSION:
        Files.createDirectory(tempDirChild.toPath()); // Creates with permissions 'drwxr-xr-x'
        
        // TO MAKE SAFE REWRITE TO:
        Files.createDirectory(tempDirChild.toPath(), PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
    }

    void vulnerableFileCreateDirectories() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directories/child");
        
        // VULNERABLE VERSION:
        Files.createDirectories(tempDirChild.toPath()); // Creates with permissions 'drwxr-xr-x'

        // TO MAKE SAFE REWRITE TO:
        Files.createDirectories(tempDirChild.toPath(), PosixFilePermissions.asFileAttribute(EnumSet.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE)));
    }

    void safeFileCreationWithPermissions() throws IOException {
        File tempFile = File.createTempFile("temp", "file.txt");
        tempFile.setReadable(false, false);
        tempFile.setReadable(true, true);
    }

    void notVulnerableCreateOnSystemPropertyDir() throws IOException {
        File tempDir = new File(System.getProperty("java.io.tmpdir"));
        tempDir.mkdir();
    }

    void notVulnerableCreateOnSystemPropertyDirs() throws IOException {
        File tempDir = new File(System.getProperty("java.io.tmpdir"));
        tempDir.mkdirs();
    }

    void safeBecauseWindows() {
        File tempDir = new File(System.getProperty("java.io.tmpdir"), "child");
        if (System.getProperty("os.name").toLowerCase().contains("windows")) {
            tempDir.mkdir(); // Safe on windows
        }
    }

    void vulnerableBecauseInvertedPosixCheck() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        // Oops, this check should be inverted
        if (tempDirChild.toPath().getFileSystem().supportedFileAttributeViews().contains("posix")) {
            Files.createDirectory(tempDirChild.toPath()); // Creates with permissions 'drwxr-xr-x'
        }
    }

    void safeBecauseCheckingForWindowsVersion() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        if (SystemUtils.IS_OS_WINDOWS_10) {
            Files.createDirectory(tempDirChild.toPath());
        }
    }

    void vulnerableBecauseCheckingForNotLinux() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        if (!SystemUtils.IS_OS_LINUX) {
            Files.createDirectory(tempDirChild.toPath());
        }
    }

    void vulnerableBecauseInvertedFileSeparatorCheck() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        // Oops, this check should be inverted
        if (File.separatorChar != '\\') {
            Files.createDirectory(tempDirChild.toPath()); // Creates with permissions 'drwxr-xr-x'
        }
    }

    void safeBecauseFileSeparatorCheck() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        if (File.separatorChar == '\\') {
            Files.createDirectory(tempDirChild.toPath());
        }
    }

    void safeBecauseInvertedFileSeperatorCheck() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        if (File.separatorChar != '/') {
            Files.createDirectory(tempDirChild.toPath());
        }
    }

    void vulnerableBecauseFileSeparatorCheckElseCase() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        if (File.separatorChar == '\\') {
            Files.createDirectory(tempDirChild.toPath()); // Safe
        } else {
            Files.createDirectory(tempDirChild.toPath()); // Vulnerable
        }
    }

    void vulnerableBecauseInvertedFileSeperatorCheckElseCase() throws IOException {
        // GIVEN:
        File tempDirChild = new File(System.getProperty("java.io.tmpdir"), "/child-create-directory");

        if (File.separatorChar != '/') {
            Files.createDirectory(tempDirChild.toPath()); // Safe
        } else {
            Files.createDirectory(tempDirChild.toPath()); // Vulnerable
        }
    }
}
