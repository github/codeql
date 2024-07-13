import java.io.IOException;
import net.lingala.zip4j.ZipFile;

public class Zip4j {
  public void PathInjection(String path) throws IOException {
    ZipFile zipfile = new ZipFile(path); // $ hasTaintFlow="path"
    zipfile.extractAll(path); // $ hasTaintFlow="path"
  }
}
