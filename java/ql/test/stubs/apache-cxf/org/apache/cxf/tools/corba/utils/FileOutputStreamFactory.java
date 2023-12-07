package org.apache.cxf.tools.corba.utils;

import java.io.OutputStream;

public class FileOutputStreamFactory implements OutputStreamFactory {
    public FileOutputStreamFactory() {}

    public FileOutputStreamFactory(String dir) {}

    public FileOutputStreamFactory(String dir, FileOutputStreamFactory p) {}

    public OutputStream createOutputStream(String name) {
        return null;
    }

    public OutputStream createOutputStream(String packageName, String name) {
        return null;
    }
}
