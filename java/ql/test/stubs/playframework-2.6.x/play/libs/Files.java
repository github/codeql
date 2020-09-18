/*
 * Copyright (C) Lightbend Inc. <https://www.lightbend.com>
 */

package play.libs;

//import javax.inject.Inject;
import java.io.File;
import java.nio.file.Path;

/** Contains TemporaryFile and TemporaryFileCreator operations. */
public final class Files {

  /** This creates temporary files when Play needs to keep overflow data on the filesystem. */
  public interface TemporaryFileCreator {
    TemporaryFile create(String prefix, String suffix);

    TemporaryFile create(Path path);

    boolean delete(TemporaryFile temporaryFile);

    // Needed for RawBuffer compatibility
  }

  /** A temporary file created by a TemporaryFileCreator. */
  public interface TemporaryFile {

    /** @return the path to the temporary file. */
    Path path();

    /**
     * @return the temporaryFile as a java.io.File.
     * @deprecated Use path() over file().
     */
    @Deprecated
    File file();

    TemporaryFileCreator temporaryFileCreator();

    default TemporaryFile moveTo(File to) {
    }

    TemporaryFile moveTo(File to, boolean replace);

    TemporaryFile atomicMoveWithFallback(File to);
  }

  /** A temporary file creator that delegates to a Scala TemporaryFileCreator. */
  public static class DelegateTemporaryFileCreator implements TemporaryFileCreator {
    //private final play.api.libs.Files.TemporaryFileCreator temporaryFileCreator;

    //@Inject
/*     public DelegateTemporaryFileCreator(
        play.api.libs.Files.TemporaryFileCreator temporaryFileCreator) {
     *///}

    public TemporaryFile create(String prefix, String suffix) {
    }

    public TemporaryFile create(Path path) {
    }

    public boolean delete(TemporaryFile temporaryFile) {
    }

    //public play.api.libs.Files.TemporaryFileCreator asScala() {}
  }

  /** Delegates to the Scala implementation. */
  public static class DelegateTemporaryFile implements TemporaryFile {

    public Path path() {
    }

    public File file() {
    }

    public TemporaryFileCreator temporaryFileCreator() {
    }

    public TemporaryFile moveTo(File to, boolean replace) {
    }

    public TemporaryFile atomicMoveWithFallback(File to) {
    }
  }

  /**
   * A temporary file creator that uses the Scala play.api.libs.Files.SingletonTemporaryFileCreator
   * class behind the scenes.
   */
  public static class SingletonTemporaryFileCreator implements TemporaryFileCreator {
    public TemporaryFile create(String prefix, String suffix) {
    }

    public TemporaryFile create(Path path) {
    }

    public boolean delete(TemporaryFile temporaryFile) {
    }

  }

  private static final TemporaryFileCreator instance = new Files.SingletonTemporaryFileCreator();

  /** @return the singleton instance of SingletonTemporaryFileCreator. */
  public static TemporaryFileCreator singletonTemporaryFileCreator() {
  }
}