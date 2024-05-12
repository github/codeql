package p;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.logging.Logger;

public class Sinks {

  // sink=p;Sinks;true;copyFileToDirectory;(Path,Path,CopyOption[]);;Argument[0];path-injection;df-generated
  // sink=p;Sinks;true;copyFileToDirectory;(Path,Path,CopyOption[]);;Argument[1];path-injection;df-generated
  // neutral=p;Sinks;copyFileToDirectory;(Path,Path,CopyOption[]);summary;df-generated
  public Path copyFileToDirectory(
      final Path sourceFile, final Path targetFile, final CopyOption... copyOptions)
      throws IOException {
    return Files.copy(sourceFile, targetFile, copyOptions);
  }

  // sink=p;Sinks;true;readUrl;(URL,Charset);;Argument[0];request-forgery;df-generated
  // neutral=p;Sinks;readUrl;(URL,Charset);summary;df-generated
  public String readUrl(final URL url, Charset encoding) throws IOException {
    try (InputStream in = url.openStream()) {
      byte[] bytes = in.readAllBytes();
      return new String(bytes, encoding);
    }
  }

  public static void main(String[] args) throws IOException {
    String foo = new Sinks().readUrl(new URL(args[0]), Charset.defaultCharset());
  }

  // neutral=p;Sinks;propagate;(String);summary;df-generated
  public void propagate(String s) {
    Logger logger = Logger.getLogger(Sinks.class.getSimpleName());
    logger.warning(s);
  }
}
