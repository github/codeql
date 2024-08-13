import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.core.io.FileUrlResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.PathResource;
import org.springframework.core.io.UrlResource;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.FileSystemUtils;

public class SpringIo {
  public void PathInjection(String path) throws IOException {
    Path fileStorageLocation = Paths.get(path).toAbsolutePath().normalize();
    Path filePath = fileStorageLocation.resolve(path).normalize();
    File pathFile = new File(path);

    new UrlResource(filePath.toUri()); // $ hasTaintFlow="toUri(...)"
    new UrlResource(filePath.toUri().toURL()); // $ hasTaintFlow="toURL(...)"
    new UrlResource("file", path); // $ hasTaintFlow="path"
    new UrlResource("file", path, "#"); // $ hasTaintFlow="path"
    new UrlResource(path); // $ hasTaintFlow="path"

    new PathResource(path); // $ hasTaintFlow="path"
    new PathResource(filePath); // $ hasTaintFlow="filePath"
    new PathResource(filePath.toUri()); // $ hasTaintFlow="toUri(...)"

    new FileUrlResource(filePath.toUri().toURL()); // $ hasTaintFlow="toURL(...)"
    new FileUrlResource(path); // $ hasTaintFlow="path"

    new FileSystemResource(pathFile); // $ hasTaintFlow="pathFile"
    new FileSystemResource(path); // $ hasTaintFlow="path"
    new FileSystemResource(filePath); // $ hasTaintFlow="filePath"
    new FileSystemResource(
        FileSystems.getFileSystem(URI.create("file:///")), path); // $ hasTaintFlow="path"

    FileSystemUtils.copyRecursively(filePath, filePath.resolve("/newPath")); // $ hasTaintFlow="filePath" hasTaintFlow="resolve(...)"
    FileSystemUtils.copyRecursively(pathFile, pathFile); // $ hasTaintFlow="pathFile"
    FileSystemUtils.deleteRecursively(pathFile); // $ hasTaintFlow="pathFile"
    FileSystemUtils.deleteRecursively(filePath); // $ hasTaintFlow="filePath"
    FileCopyUtils.copy(pathFile, pathFile); // $ hasTaintFlow="pathFile"
    FileCopyUtils.copyToByteArray(pathFile); // $ hasTaintFlow="pathFile"
  }
}
