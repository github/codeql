package org.apache.cxf.tools.corba.utils;

import java.io.OutputStream;

public interface OutputStreamFactory {
    OutputStream createOutputStream(String name);

    OutputStream createOutputStream(String packageName, String name);
}
