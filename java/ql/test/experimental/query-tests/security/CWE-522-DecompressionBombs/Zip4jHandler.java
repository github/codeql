import net.lingala.zip4j.model.LocalFileHeader;
import net.lingala.zip4j.io.inputstream.ZipInputStream;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileOutputStream;

public class Zip4jHandler {
    public static void zip4jZipInputStream(InputStream inputStream) throws IOException {
        LocalFileHeader localFileHeader;
        int readLen;
        byte[] readBuffer = new byte[4096];
        try (ZipInputStream zipInputStream = new ZipInputStream(inputStream)) {
            while ((localFileHeader = zipInputStream.getNextEntry()) != null) {
                File extractedFile = new File(localFileHeader.getFileName());
                try (OutputStream outputStream = new FileOutputStream(extractedFile)) {
                    while ((readLen = zipInputStream.read(readBuffer)) != -1) { // $ hasTaintFlow="zipInputStream"
                        outputStream.write(readBuffer, 0, readLen);
                    }
                }
            }
        }
    }

    public static void zip4jZipInputStreamSafe(InputStream inputStream) throws IOException {
        LocalFileHeader localFileHeader;
        int readLen;
        byte[] readBuffer = new byte[4096];
        try (ZipInputStream zipInputStream = new ZipInputStream(inputStream)) { 
            while ((localFileHeader = zipInputStream.getNextEntry()) != null) {
                File extractedFile = new File(localFileHeader.getFileName());
                try (OutputStream outputStream = new FileOutputStream(extractedFile)) {
                    int totallRead = 0;
                    while ((readLen = zipInputStream.read(readBuffer)) != -1) { // $ SPURIOUS: hasTaintFlow="zipInputStream"
                        totallRead += readLen;
                        if (totallRead > 1024 * 1024 * 4) {
                            System.out.println("potential Bomb");
                            break;
                        }
                        outputStream.write(readBuffer, 0, readLen);
                    }
                }
            }
        }
    }
}
