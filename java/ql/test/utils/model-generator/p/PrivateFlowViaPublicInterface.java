package p;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class PrivateFlowViaPublicInterface {

    public static interface SPI {
        OutputStream openStream() throws IOException;
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

    public static SPI createAnSPI(File file) {
        return new PrivateImplWithSink(file);
    }

}