package com.PathInjection;

import java.io.*;
import java.io.IOException;
import java.net.URI;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.core.io.*;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.FileSystemUtils;
import org.springframework.util.ResourceUtils;

public class SpringIoPathInjection {
  public void PathInjection(String path) throws IOException {
    Path fileStorageLocation = Paths.get(path).toAbsolutePath().normalize();
    Path filePath = fileStorageLocation.resolve(path).normalize();
    File pathFile = new File(path);

    new UrlResource(filePath.toUri()); // $ PathInjection
    new UrlResource(filePath.toUri().toURL()); // $ PathInjection
    new UrlResource("file", path); // $ PathInjection
    new UrlResource("file", path, "#"); // $ PathInjection
    new UrlResource(path); // $ PathInjection

    new PathResource(path); // $ PathInjection
    new PathResource(filePath); // $ PathInjection
    new PathResource(filePath.toUri()); // $ PathInjection

    new FileUrlResource(filePath.toUri().toURL()); // $ PathInjection
    new FileUrlResource(path); // $ PathInjection

    new FileSystemResource(pathFile); // $ PathInjection
    new FileSystemResource(path); // $ PathInjection
    new FileSystemResource(filePath); // $ PathInjection
    new FileSystemResource(
        FileSystems.getFileSystem(URI.create("file:///")), path); // $ PathInjection

    FileSystemUtils.copyRecursively(filePath, filePath.resolve("/newPath")); // $ PathInjection
    FileSystemUtils.copyRecursively(pathFile, pathFile); // $ PathInjection
    FileSystemUtils.deleteRecursively(pathFile); // $ PathInjection
    FileSystemUtils.deleteRecursively(filePath); // $ PathInjection
    FileCopyUtils.copy(pathFile, pathFile); // $ PathInjection
    FileCopyUtils.copyToByteArray(pathFile); // $ PathInjection
    FileCopyUtils.copyToString(new FileReader("fa"));
  }
}
