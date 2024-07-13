import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.BufferedInputStream;
import java.nio.file.Files;
import java.nio.file.Path;

import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.compressors.CompressorException;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.compressors.CompressorStreamFactory;
import org.apache.commons.compress.compressors.lz4.*;
import org.apache.commons.compress.archivers.ar.ArArchiveInputStream;
import org.apache.commons.compress.archivers.arj.ArjArchiveInputStream;
import org.apache.commons.compress.archivers.cpio.CpioArchiveInputStream;
import org.apache.commons.compress.archivers.jar.JarArchiveInputStream;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.commons.compress.compressors.lzma.LZMACompressorInputStream;
import org.apache.commons.compress.compressors.pack200.Pack200CompressorInputStream;
import org.apache.commons.compress.compressors.snappy.SnappyCompressorInputStream;
import org.apache.commons.compress.compressors.xz.XZCompressorInputStream;
import org.apache.commons.compress.compressors.zstandard.ZstdCompressorInputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;
import org.apache.commons.compress.compressors.brotli.BrotliCompressorInputStream;
import org.apache.commons.compress.compressors.bzip2.BZip2CompressorInputStream;
import org.apache.commons.compress.compressors.deflate.DeflateCompressorInputStream;
import org.apache.commons.compress.compressors.deflate64.Deflate64CompressorInputStream;
import org.apache.commons.compress.compressors.z.ZCompressorInputStream;

public class CommonsCompressHandler {

    static void commonsCompressArchiveInputStream(InputStream inputStream) throws ArchiveException {
        new ArArchiveInputStream(inputStream); // $ hasTaintFlow="inputStream"
        new ArjArchiveInputStream(inputStream); // $ hasTaintFlow="inputStream"
        new CpioArchiveInputStream(inputStream); // $ hasTaintFlow="inputStream"
        new JarArchiveInputStream(inputStream); // $ hasTaintFlow="inputStream"
        new ZipArchiveInputStream(inputStream); // $ hasTaintFlow="inputStream"
    }

    public static void commonsCompressorInputStream(InputStream inputStream) throws IOException {
        BufferedInputStream in = new BufferedInputStream(inputStream);
        OutputStream out = Files.newOutputStream(Path.of("tmpfile"));
        GzipCompressorInputStream gzIn = new GzipCompressorInputStream(in); // $ hasTaintFlow="in"
        // for testing
        new BrotliCompressorInputStream(in); // $ hasTaintFlow="in"
        new BZip2CompressorInputStream(in); // $ hasTaintFlow="in"
        new DeflateCompressorInputStream(in); // $ hasTaintFlow="in"
        new Deflate64CompressorInputStream(in); // $ hasTaintFlow="in"
        new BlockLZ4CompressorInputStream(in); // $ hasTaintFlow="in"
        new LZMACompressorInputStream(in); // $ hasTaintFlow="in"
        new Pack200CompressorInputStream(in); // $ hasTaintFlow="in"
        new SnappyCompressorInputStream(in); // $ hasTaintFlow="in"
        new XZCompressorInputStream(in); // $ hasTaintFlow="in"
        new ZCompressorInputStream(in); // $ hasTaintFlow="in"
        new ZstdCompressorInputStream(in); // $ hasTaintFlow="in"

        int buffersize = 4096;
        final byte[] buffer = new byte[buffersize];
        int n = 0;
        while (-1 != (n = gzIn.read(buffer))) {
            out.write(buffer, 0, n);
        }
        out.close();
        gzIn.close();
    }

    static void commonsCompressArchiveInputStream2(InputStream inputStream) {
        byte[] readBuffer = new byte[4096];
        try (org.apache.commons.compress.archivers.zip.ZipArchiveInputStream zipInputStream =
                     new org.apache.commons.compress.archivers.zip.ZipArchiveInputStream(inputStream)) { // $ hasTaintFlow="inputStream"
            ArchiveEntry entry = null;
            while ((entry = zipInputStream.getNextEntry()) != null) {
                if (!zipInputStream.canReadEntryData(entry)) {
                    continue;
                }
                File f = new File("tmpfile");
                try (OutputStream outputStream = new FileOutputStream(f)) {
                    int readLen;
                    while ((readLen = zipInputStream.read(readBuffer)) != -1) {
                        outputStream.write(readBuffer, 0, readLen);
                    }
                }
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    static void commonsCompressArchiveStreamFactory(InputStream inputStream)
            throws IOException, ArchiveException {
        BufferedInputStream bin = new BufferedInputStream(inputStream);
        ArchiveInputStream zipInputStream = new ArchiveStreamFactory().createArchiveInputStream(bin);
        ArchiveEntry entry = null;
        byte[] readBuffer = new byte[4096];
        while ((entry = zipInputStream.getNextEntry()) != null) {
            if (!zipInputStream.canReadEntryData(entry)) {
                continue;
            }
            File f = new File("tmpfile");
            try (OutputStream outputStream = new FileOutputStream(f)) {
                int readLen;
                while ((readLen = zipInputStream.read(readBuffer)) != -1) {  // $ hasTaintFlow="zipInputStream"
                    outputStream.write(readBuffer, 0, readLen);
                }
            }
        }
    }

    static void commonsCompressCompressorStreamFactory(InputStream inputStream)
            throws IOException, CompressorException {
        BufferedInputStream bin = new BufferedInputStream(inputStream);
        CompressorInputStream in = new CompressorStreamFactory().createCompressorInputStream(bin);
        OutputStream out = Files.newOutputStream(Path.of("tmpfile"));
        int buffersize = 4096;
        final byte[] buffer = new byte[buffersize];
        int n = 0;
        while (-1 != (n = in.read(buffer))) { // $ hasTaintFlow="in"
            out.write(buffer, 0, n);
        }
        out.close();
        in.close();
    }
}
