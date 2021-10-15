package org.apache.commons.io;
import java.io.*;
import java.util.*;

public class IOUtils {
  public static BufferedInputStream buffer(InputStream inputStream) { return null; }
  public static void copy(InputStream input, Writer output, String inputEncoding) throws IOException { }
  public static long copyLarge(Reader input, Writer output) throws IOException { return 42; }
  public static int read(InputStream input, byte[] buffer) throws IOException { return 42; }
  public static void readFully(InputStream input, byte[] buffer) throws IOException { }
  public static byte[] readFully(InputStream input, int length) throws IOException { return null; }
  public static List<String> readLines(InputStream input, String encoding) throws IOException { return null; }
  public static InputStream toBufferedInputStream(InputStream input) throws IOException { return null; }
  public static BufferedReader toBufferedReader(Reader reader) { return null; }
  public static byte[] toByteArray(InputStream input, int size) throws IOException { return null; }
  public static char[] toCharArray(InputStream is, String encoding) throws IOException { return null; }
  public static InputStream toInputStream(String input, String encoding) throws IOException { return null; }
  public static String toString(InputStream input, String encoding) throws IOException { return null; }
  public static void write(char[] data, Writer output) throws IOException { }
  public static void writeChunked(char[] data, Writer output) throws IOException { }
  public static void writeLines(Collection<?> lines, String lineEnding, Writer writer) throws IOException { }
}
