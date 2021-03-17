package org.springframework.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.file.Files;
import org.springframework.lang.Nullable;

public abstract class FileCopyUtils {
    public static final int BUFFER_SIZE = 4096;

    public FileCopyUtils() {
    }

    public static int copy(File in, File out) throws IOException {
        return 1;
    }

    public static void copy(byte[] in, File out) throws IOException {}

    public static byte[] copyToByteArray(File in) throws IOException {
        return null;
    }

    public static int copy(InputStream in, OutputStream out) throws IOException {
        return 1;
    }

    public static void copy(byte[] in, OutputStream out) throws IOException {}

    public static byte[] copyToByteArray(@Nullable InputStream in) throws IOException {
        return null;    
    }

    public static int copy(Reader in, Writer out) throws IOException {
        return 1;
    }

    public static void copy(String in, Writer out) throws IOException {}

    public static String copyToString(@Nullable Reader in) throws IOException {
        return null;
    }

    private static void close(Closeable closeable) {}
}
