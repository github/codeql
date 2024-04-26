package com.semmle.util.trap;

import com.semmle.util.zip.MultiMemberGZIPInputStream;
import io.airlift.compress.zstd.ZstdInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

public class CompressedFileInputStream {
  /**
   * Create an input stream for reading the uncompressed data from a (possibly) compressed file,
   * with the decompression method chosen based on the file extension.
   *
   * @param f The compressed file to read
   * @return An input stream from which you can read the file's uncompressed data.
   * @throws IOException From the underlying decompression input stream.
   */
  public static InputStream fromFile(Path f) throws IOException {
    InputStream fileInputStream = Files.newInputStream(f);
    String fileName = f.getFileName().toString();
    if (fileName.endsWith(".gz")) {
      return new MultiMemberGZIPInputStream(fileInputStream, 8192);
    //} else if (fileName.endsWith(".br")) {
    //  return new BrotliInputStream(fileInputStream);
    } else if (fileName.endsWith(".zst")) {
      return new WrappedZstdInputStream(fileInputStream);
    } else {
      return fileInputStream;
    }
  }

  // Turn the MalformedInputException thrown by the ZstdInputStream into an IOException,
  // which will be handled as a non-catastrophic error during TRAP import.
  private static class WrappedZstdInputStream extends ZstdInputStream {
    public WrappedZstdInputStream(InputStream in) {
      super(in);
    }

    @Override
    public int read() throws IOException {
      try {
        return super.read();
      } catch (io.airlift.compress.MalformedInputException e) {
        throw new IOException("Zstd stream decoding failed", e);
      }
    }

    @Override
    public int read(final byte[] outputBuffer, final int outputOffset, final int outputLength)
        throws IOException {
      try {
        return super.read(outputBuffer, outputOffset, outputLength);
      } catch (io.airlift.compress.MalformedInputException e) {
        throw new IOException("Zstd stream decoding failed", e);
      }
    }
  }
}
