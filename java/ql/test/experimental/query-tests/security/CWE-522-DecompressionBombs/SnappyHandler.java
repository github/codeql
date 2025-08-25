import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.xerial.snappy.SnappyInputStream;

public class SnappyHandler {
    public static void SnappyZipInputStream(InputStream inputStream) throws IOException {
        int readLen;
        byte[] readBuffer = new byte[4096];
        try (SnappyInputStream zipInputStream = new SnappyInputStream(inputStream)) {
            try (OutputStream outputStream = Files.newOutputStream(Paths.get("extractedFile"))) {
                while ((readLen = zipInputStream.read(readBuffer)) != -1) { // $ hasTaintFlow="zipInputStream"
                    outputStream.write(readBuffer, 0, readLen);
                }
            }
        }
    }
}
