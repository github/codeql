import java.util.zip.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.ZipEntry;

public class GoodExample {
    public static void ZipInputStreamSafe(String filename) throws IOException {
        int UncompressedSizeThreshold = 10 * 1024 * 1024; // 10MB
        int BUFFERSIZE = 256;
        FileInputStream fis = new FileInputStream(filename);
        try (ZipInputStream zis = new ZipInputStream(new BufferedInputStream(fis))) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                int count;
                byte[] data = new byte[BUFFERSIZE];
                FileOutputStream fos = new FileOutputStream(entry.getName());
                BufferedOutputStream dest = new BufferedOutputStream(fos, BUFFERSIZE);
                int totalRead = 0;
                while ((count = zis.read(data, 0, BUFFERSIZE)) != -1) {
                    totalRead = totalRead + count;
                    if (totalRead > UncompressedSizeThreshold) {
                        System.out.println("This Compressed file can be a bomb!");
                        break;
                    }
                    dest.write(data, 0, count);
                }
                dest.flush();
                dest.close();
                zis.closeEntry();
            }
        }
    }
}