package org.apache.cxf.tools.util;

import java.io.File;
import java.io.Writer;

public class FileWriterUtil {
    public FileWriterUtil() {}

    public FileWriterUtil(String targetDir, OutputStreamCreator osc) {}

    public File buildDir(String packageName) {
        return null;
    }

    public File getFileToWrite(String packageName, String fileName) {
        return null;
    }

    public Writer getWriter(File fn, String encoding) {
        return null;
    }

    public Writer getWriter(String packageName, String fileName) {
        return null;
    }

    public Writer getWriter(String packageName, String fileName, String encoding) {
        return null;
    }
}
