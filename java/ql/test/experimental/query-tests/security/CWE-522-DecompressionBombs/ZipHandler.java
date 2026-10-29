import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.BufferedInputStream;
import java.util.Enumeration;
import java.util.zip.CRC32;
import java.util.zip.CheckedInputStream;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.GZIPInputStream;
import java.util.zip.InflaterInputStream;
import java.util.zip.Inflater;
import java.util.zip.DataFormatException;

public class ZipHandler {
    public static void ZipInputStreamSafe(InputStream inputStream) throws IOException {
        final int BUFFER = 512;
        final long TOOBIG = 0x6400000; // Max size of unzipped data, 100MB
        final int TOOMANY = 1024;
        // FileInputStream fis = new FileInputStream(filename);
        CRC32 checkSum = new CRC32();
        CheckedInputStream gzis = new CheckedInputStream(inputStream, checkSum);
        try (ZipInputStream zis = new ZipInputStream(new BufferedInputStream(inputStream))) {
            ZipEntry entry;
            int entries = 0;
            long total = 0;
            while ((entry = zis.getNextEntry()) != null) {
                System.out.println("Extracting: " + entry);
                int count;
                byte[] data = new byte[BUFFER];
                if (entry.isDirectory()) {
                    System.out.println("Creating directory " + entry.getName());
                    continue;
                }
                FileOutputStream fos = new FileOutputStream("/tmp/tmptmp");
                BufferedOutputStream dest = new BufferedOutputStream(fos, BUFFER);
                while (total + BUFFER <= TOOBIG && (count = zis.read(data, 0, BUFFER)) != -1) { // $ SPURIOUS: hasTaintFlow="zis"
                    dest.write(data, 0, count);
                    total += count;
                }
                dest.flush();
                dest.close();
                zis.closeEntry();
                entries++;
                if (entries > TOOMANY) {
                    throw new IllegalStateException("Too many files to unzip.");
                }
                if (total + BUFFER > TOOBIG) {
                    throw new IllegalStateException("File being unzipped is too big.");
                }
            }
        }
    }

    // it seems that previously getSize could be bypassed by forged headers, so I tested following
    // method with a forged header zip bomb, the getSize() return the forged header but read method
    // will read bytes until the getSize() value that this makes getSize() safe for now.
    public static void ZipInputStreamSafe2(InputStream inputStream) throws IOException {
        int BUFFER = 512;
        int TOOBIG = 100 * 1024 * 1024; // 100MB
        //        FileInputStream fis = new FileInputStream(filename);
        try (ZipInputStream zis = new ZipInputStream(new BufferedInputStream(inputStream))) { 
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                System.out.println("Extracting: " + entry);
                int count;
                byte[] data = new byte[BUFFER];
                // Write the files to the disk, but only if the file is not insanely big
                if (entry.getSize() > TOOBIG) {
                    throw new IllegalStateException("File to be unzipped is huge.");
                }
                if (entry.getSize() == -1) {
                    throw new IllegalStateException("File to be unzipped might be huge.");
                }
                FileOutputStream fos = new FileOutputStream(entry.getName());
                BufferedOutputStream dest = new BufferedOutputStream(fos, BUFFER);
                while ((count = zis.read(data, 0, BUFFER)) != -1) { // $ SPURIOUS: hasTaintFlow="zis"
                    dest.write(data, 0, count);
                }
                dest.flush();
                dest.close();
                zis.closeEntry();
            }
        }
    }

    public static void ZipInputStreamUnsafe(InputStream inputStream) throws IOException {
        int BUFFER = 512;
        //        FileInputStream fis = new FileInputStream(filename);
        try (ZipInputStream zis = new ZipInputStream(new BufferedInputStream(inputStream))) { 
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                System.out.println("Extracting: " + entry);
                int count;
                byte[] data = new byte[BUFFER];
                // Write the files to the disk
                FileOutputStream fos = new FileOutputStream(entry.getName()); 
                BufferedOutputStream dest = new BufferedOutputStream(fos, BUFFER);
                while ((count = zis.read(data, 0, BUFFER)) != -1) { // $ hasTaintFlow="zis" 
                    dest.write(data, 0, count);
                }
                dest.flush();
                dest.close();
                zis.closeEntry();
            }
        }
    }

    public static void GZipInputStreamUnsafe(InputStream inputStream) throws IOException {
        int BUFFER = 512;
        try (GZIPInputStream gzis = new GZIPInputStream(inputStream)) { 
            int count;
            byte[] data = new byte[BUFFER];
            FileOutputStream fos = new FileOutputStream("/tmp/tmp");
            BufferedOutputStream dest = new BufferedOutputStream(fos, BUFFER);
            while ((count = gzis.read(data, 0, BUFFER)) != -1) { // $ hasTaintFlow="gzis"
                dest.write(data, 0, count);
            }
            dest.flush();
            dest.close();
        }
    }

    public static void InflaterInputStreamUnsafe(InputStream inputStream) throws IOException {
        int BUFFER = 512;
        try (InflaterInputStream Izis = new InflaterInputStream(inputStream)) { 
            int count;
            byte[] data = new byte[BUFFER];
            FileOutputStream fos = new FileOutputStream("/tmp/tmp");
            BufferedOutputStream dest = new BufferedOutputStream(fos, BUFFER);
            while ((count = Izis.read(data, 0, BUFFER)) != -1) { // $ hasTaintFlow="Izis"
                dest.write(data, 0, count);
            }
            dest.flush();
            dest.close();
        }
    }

    public static void InflaterUnsafe(byte[] inputBytes) throws DataFormatException, IOException {
        Inflater inflater = new Inflater();
        inflater.setInput(inputBytes); // $ hasTaintFlow="inputBytes"
        try (final ByteArrayOutputStream outputStream = new ByteArrayOutputStream(inputBytes.length)) {
            byte[] buffer = new byte[1024];
            while (!inflater.finished()) {
                final int count = inflater.inflate(buffer);
                outputStream.write(buffer, 0, count);
            }
            outputStream.toByteArray();
        }
    }

    public static void ZipFile1(String zipFilePath) throws DataFormatException, IOException {
        try {
            System.out.println("zipFilePath = " + zipFilePath);
            ZipFile zipFile = new ZipFile(zipFilePath);
            Enumeration<? extends ZipEntry> entries = zipFile.entries();
            while (entries.hasMoreElements()) {
                ZipEntry entry = entries.nextElement();
                if (entry.isDirectory()) {
                    System.out.print("dir  : " + entry.getName());
                    String destPath = "tmp" + File.separator + entry.getName();
                    System.out.println(" => " + destPath);
                    File file = new File(destPath);
                    file.mkdirs();
                } else {
                    String destPath = "tmp" + File.separator + entry.getName();

                    try (InputStream inputStream = zipFile.getInputStream(entry); // $ hasTaintFlow="zipFile"
                         FileOutputStream outputStream = new FileOutputStream(destPath);) {
                        int data = inputStream.read();
                        while (data != -1) {
                            outputStream.write(data);
                            data = inputStream.read();
                        }
                    }
                    System.out.println("file : " + entry.getName() + " => " + destPath);
                }
            }
        } catch (IOException e) {
            throw new RuntimeException("Error unzipping file " + zipFilePath, e);
        }
    }
}
