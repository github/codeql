import java.io.IOException;

public class ZipFile {
  public void PathInjection(String path) throws IOException {
    new java.util.zip.ZipFile(path); // $ hasTaintFlow="path"
  }
}
