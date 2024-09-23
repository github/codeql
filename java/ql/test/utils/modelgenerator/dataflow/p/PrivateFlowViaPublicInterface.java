package p;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class PrivateFlowViaPublicInterface {

  static class RandomPojo {
    public File someFile = new File("someFile");
  }

  public static interface SPI {
    OutputStream openStream() throws IOException;

    // neutral=p;PrivateFlowViaPublicInterface$SPI;openStreamNone;();summary;df-generated
    default OutputStream openStreamNone() throws IOException {
      return null;
    }
  }

  private static final class PrivateImplWithSink implements SPI {

    private File file;

    public PrivateImplWithSink(File file) {
      this.file = file;
    }

    // summary=p;PrivateFlowViaPublicInterface$SPI;true;openStream;();;Argument[this];ReturnValue;taint;df-generated
    @Override
    public OutputStream openStream() throws IOException {
      return new FileOutputStream(file);
    }
  }

  private static final class PrivateImplWithRandomField implements SPI {

    public PrivateImplWithRandomField(File file) {}

    @Override
    public OutputStream openStream() throws IOException {
      return null;
    }

    @Override
    public OutputStream openStreamNone() throws IOException {
      return new FileOutputStream(new RandomPojo().someFile);
    }
  }

  // summary=p;PrivateFlowViaPublicInterface;true;createAnSPI;(File);;Argument[0];ReturnValue;taint;df-generated
  // contentbased-summary=p;PrivateFlowViaPublicInterface;true;createAnSPI;(File);;Argument[0];ReturnValue.SyntheticField[p.PrivateFlowViaPublicInterface$PrivateImplWithSink.file];value;dfc-generated
  public static SPI createAnSPI(File file) {
    return new PrivateImplWithSink(file);
  }

  // neutral=p;PrivateFlowViaPublicInterface;createAnSPIWithoutTrackingFile;(File);summary;df-generated
  public static SPI createAnSPIWithoutTrackingFile(File file) {
    return new PrivateImplWithRandomField(file);
  }
}
