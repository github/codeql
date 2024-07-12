package com.PathInjection;

import java.io.*;
import java.nio.channels.AsynchronousFileChannel;
import java.nio.file.*;
import java.nio.file.attribute.FileAttribute;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class fileAttr implements FileAttribute<String> {
  public String name() {
    return "file";
  }

  public String value() {
    return "value";
  }
}

public class CommonsIOPathInjection {
  public void PathInjection(Path src, File srcF) throws IOException {
    AsynchronousFileChannel.open(src); // $ hasTaintFlow
    AsynchronousFileChannel.open(src, LinkOption.NOFOLLOW_LINKS); // $ hasTaintFlow
    AsynchronousFileChannel.open(
        src, LinkOption.NOFOLLOW_LINKS, LinkOption.NOFOLLOW_LINKS); // $ hasTaintFlow
    ExecutorService executor = Executors.newFixedThreadPool(10);
    AsynchronousFileChannel.open(
        src, Set.of(LinkOption.NOFOLLOW_LINKS), executor); // $ hasTaintFlow
    AsynchronousFileChannel.open(
        src, // $ hasTaintFlow
        Set.of(LinkOption.NOFOLLOW_LINKS),
        executor,
        new fileAttr());

    FileSystems.getFileSystem(srcF.toURI()); // $ hasTaintFlow
  }
}
