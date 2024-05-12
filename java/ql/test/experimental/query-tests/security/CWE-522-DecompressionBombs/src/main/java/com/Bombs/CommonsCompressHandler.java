package com.Bombs;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import org.apache.commons.compress.archivers.*;
import org.apache.commons.compress.compressors.CompressorException;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.compressors.CompressorStreamFactory;
import org.apache.commons.compress.compressors.gzip.*;

public class CommonsCompressHandler {
  public static void commonsCompressorInputStream(InputStream inputStream) throws IOException {
    BufferedInputStream in = new BufferedInputStream(inputStream);
    OutputStream out = Files.newOutputStream(Path.of("tmpfile"));
    GzipCompressorInputStream gzIn =
        new org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream(in);
    // for testing
    new org.apache.commons.compress.compressors.brotli.BrotliCompressorInputStream(in);
    new org.apache.commons.compress.compressors.bzip2.BZip2CompressorInputStream(in);
    new org.apache.commons.compress.compressors.deflate.DeflateCompressorInputStream(in);
    new org.apache.commons.compress.compressors.deflate64.Deflate64CompressorInputStream(in);
    new org.apache.commons.compress.compressors.lz4.BlockLZ4CompressorInputStream(in);
    new org.apache.commons.compress.compressors.lzma.LZMACompressorInputStream(in);
    new org.apache.commons.compress.compressors.pack200.Pack200CompressorInputStream(in);
    new org.apache.commons.compress.compressors.snappy.SnappyCompressorInputStream(in);
    new org.apache.commons.compress.compressors.xz.XZCompressorInputStream(in);
    new org.apache.commons.compress.compressors.z.ZCompressorInputStream(in);
    new org.apache.commons.compress.compressors.zstandard.ZstdCompressorInputStream(in);

    int buffersize = 4096;
    final byte[] buffer = new byte[buffersize];
    int n = 0;
    while (-1 != (n = gzIn.read(buffer))) {
      out.write(buffer, 0, n);
    }
    out.close();
    gzIn.close();
  }

  static void commonsCompressArchiveInputStream(InputStream inputStream) throws ArchiveException {
    new org.apache.commons.compress.archivers.ar.ArArchiveInputStream(inputStream);
    new org.apache.commons.compress.archivers.arj.ArjArchiveInputStream(inputStream);
    new org.apache.commons.compress.archivers.cpio.CpioArchiveInputStream(inputStream);
    new org.apache.commons.compress.archivers.jar.JarArchiveInputStream(inputStream);
    new org.apache.commons.compress.archivers.zip.ZipArchiveInputStream(inputStream);
  }

  static void commonsCompressArchiveInputStream2(InputStream inputStream) {
    byte[] readBuffer = new byte[4096];
    try (org.apache.commons.compress.archivers.zip.ZipArchiveInputStream zipInputStream =
        new org.apache.commons.compress.archivers.zip.ZipArchiveInputStream(inputStream)) {
      ArchiveEntry entry = null;
      while ((entry = zipInputStream.getNextEntry()) != null) {
        if (!zipInputStream.canReadEntryData(entry)) {
          continue;
        }
        File f = new File("tmpfile");
        try (OutputStream outputStream = new FileOutputStream(f)) {
          int readLen;
          while ((readLen = zipInputStream.read(readBuffer)) != -1) { // BAD
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
        while ((readLen = zipInputStream.read(readBuffer)) != -1) { // BAD
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
    while (-1 != (n = in.read(buffer))) { // BAD
      out.write(buffer, 0, n);
    }
    out.close();
    in.close();
  }
}
