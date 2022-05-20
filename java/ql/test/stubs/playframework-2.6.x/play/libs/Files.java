/*
 * Copyright (C) Lightbend Inc. <https://www.lightbend.com>
 */

package play.libs;

import java.io.File;
import java.nio.file.Path;

public final class Files {

  public interface TemporaryFileCreator {
    TemporaryFile create(String prefix, String suffix);

    TemporaryFile create(Path path);

    boolean delete(TemporaryFile temporaryFile);
  }

  public interface TemporaryFile {

    Path path();

    @Deprecated
    File file();

    TemporaryFileCreator temporaryFileCreator();

    default TemporaryFile moveTo(File to) {
      return null;
    }

    TemporaryFile moveTo(File to, boolean replace);

    TemporaryFile atomicMoveWithFallback(File to);
  }

  public static class DelegateTemporaryFileCreator implements TemporaryFileCreator {

    public TemporaryFile create(String prefix, String suffix) {
      return null;
    }

    public TemporaryFile create(Path path) {
      return null;
    }

    public boolean delete(TemporaryFile temporaryFile) {
      return true;
    }
  }

  public static class DelegateTemporaryFile implements TemporaryFile {

    public Path path() {
      return null;
    }

    public File file() {
      return null;
    }

    public TemporaryFileCreator temporaryFileCreator() {
      return null;
    }

    public TemporaryFile moveTo(File to, boolean replace) {
      return null;
    }

    public TemporaryFile atomicMoveWithFallback(File to) {
      return null;
    }
  }

  public static class SingletonTemporaryFileCreator implements TemporaryFileCreator {
    public TemporaryFile create(String prefix, String suffix) {
      return null;
    }

    public TemporaryFile create(Path path) {
      return null;
    }

    public boolean delete(TemporaryFile temporaryFile) {
      return true;
    }
  }

  private static final TemporaryFileCreator instance = new Files.SingletonTemporaryFileCreator();

  public static TemporaryFileCreator singletonTemporaryFileCreator() {
    return null;
  }
}
