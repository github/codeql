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

    new UrlResource(filePath.toUri()); // $ hasTaintFlow
    new UrlResource(filePath.toUri().toURL()); // $ hasTaintFlow
    new UrlResource("file", path); // $ hasTaintFlow
    new UrlResource("file", path, "#"); // $ hasTaintFlow
    new UrlResource(path); // $ hasTaintFlow

    new PathResource(path); // $ hasTaintFlow
    new PathResource(filePath); // $ hasTaintFlow
    new PathResource(filePath.toUri()); // $ hasTaintFlow

    new FileUrlResource(filePath.toUri().toURL()); // $ hasTaintFlow
    new FileUrlResource(path); // $ hasTaintFlow

    new FileSystemResource(pathFile); // $ hasTaintFlow
    new FileSystemResource(path); // $ hasTaintFlow
    new FileSystemResource(filePath); // $ hasTaintFlow
    new FileSystemResource(
        FileSystems.getFileSystem(URI.create("file:///")), path); // $ hasTaintFlow

    FileSystemUtils.copyRecursively(filePath, filePath.resolve("/newPath")); // $ hasTaintFlow
    FileSystemUtils.copyRecursively(pathFile, pathFile); // $ hasTaintFlow
    FileSystemUtils.deleteRecursively(pathFile); // $ hasTaintFlow
    FileSystemUtils.deleteRecursively(filePath); // $ hasTaintFlow
    FileCopyUtils.copy(pathFile, pathFile); // $ hasTaintFlow
    FileCopyUtils.copyToByteArray(pathFile); // $ hasTaintFlow
  }
}
