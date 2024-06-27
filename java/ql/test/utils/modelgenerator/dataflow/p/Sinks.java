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

  public Object tainted;

  // Defined as a sink in the model file next to the test.
  // neutral=p;Sinks;sink;(Object);summary;df-generated
  public void sink(Object o) {}

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

  // New sink as the value of a public field is propagated to a sink.
  // sink=p;Sinks;true;fieldSink;();;Argument[this];test-sink;df-generated
  // neutral=p;Sinks;fieldSink;();summary;df-generated
  public void fieldSink() {
    sink(tainted);
  }

  // Not a new sink as this method is already defined as a manual
  // sink neutral.
  // neutral=p;Sinks;hasManualSinkNeutral;(Object);summary;df-generated
  public void hasManualSinkNeutral(Object o) {
    sink(o);
  }

  // sink=p;Sinks;true;compoundPropgate;(Sinks);;Argument[0];test-sink;df-generated
  // neutral=p;Sinks;compoundPropgate;(Sinks);summary;df-generated
  public void compoundPropgate(Sinks s) {
    s.fieldSink();
  }

  // Not a new sink because a simple type is used in an intermediate step
  // neutral=p;Sinks;wrapSinkSimpleType;(String);summary;df-generated
  public void wrapSinkSimpleType(String s) {
    Boolean b = s == "hello";
    sink(b);
  }

  // Not a new sink as this callable already has a manual sink.
  // neutral=p;Sinks;manualSinkAlreadyDefined;(Object);summary;df-generated
  public void manualSinkAlreadyDefined(Object o) {
    sink(o);
  }
}
