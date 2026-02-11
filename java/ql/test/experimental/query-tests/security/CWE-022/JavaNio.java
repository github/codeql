import java.io.IOException;
import java.io.File;
import java.nio.channels.AsynchronousFileChannel;
import java.nio.file.Path;
import java.nio.file.LinkOption;
import java.nio.file.FileSystems;
import java.nio.file.attribute.FileAttribute;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class JavaNio {
  static class FileAttr implements FileAttribute<String> {
    public String name() {
      return "file";
    }

    public String value() {
      return "value";
    }
  }

  public void PathInjection(Path src, File srcF) throws IOException {
    AsynchronousFileChannel.open(src); // $ hasTaintFlow="src"
    AsynchronousFileChannel.open(src, LinkOption.NOFOLLOW_LINKS); // $ hasTaintFlow="src"
    AsynchronousFileChannel.open(
        src, LinkOption.NOFOLLOW_LINKS, LinkOption.NOFOLLOW_LINKS); // $ hasTaintFlow="src"
    ExecutorService executor = Executors.newFixedThreadPool(10);
    AsynchronousFileChannel.open(
        src, Set.of(LinkOption.NOFOLLOW_LINKS), executor); // $ hasTaintFlow="src"
    AsynchronousFileChannel.open(
        src, // $ hasTaintFlow="src"
        Set.of(LinkOption.NOFOLLOW_LINKS),
        executor,
        new FileAttr());

    FileSystems.getFileSystem(srcF.toURI()); // $ hasTaintFlow="toURI(...)"
  }
}
