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

        default OutputStream openStreamNone() throws IOException {
            return null;
        };
    }

    private static final class PrivateImplWithSink implements SPI {

        private File file;

        public PrivateImplWithSink(File file) {
            this.file = file;
        }

        @Override
        public OutputStream openStream() throws IOException {
            return new FileOutputStream(file);
        }

    }
    
    private static final class PrivateImplWithRandomField implements SPI {

        public PrivateImplWithRandomField(File file) {
        }

        @Override
        public OutputStream openStream() throws IOException {
            return null;
        }
        
        @Override
        public OutputStream openStreamNone() throws IOException {
            return new FileOutputStream(new RandomPojo().someFile);
        }

    }

    public static SPI createAnSPI(File file) {
        return new PrivateImplWithSink(file);
    }
    
    public static SPI createAnSPIWithoutTrackingFile(File file) {
        return new PrivateImplWithRandomField(file);
    }

}