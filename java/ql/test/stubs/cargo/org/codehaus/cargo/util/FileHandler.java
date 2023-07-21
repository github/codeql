// Generated automatically from org.codehaus.cargo.util.FileHandler for testing purposes

package org.codehaus.cargo.util;

import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;
import org.codehaus.cargo.util.XmlReplacement;
import org.codehaus.cargo.util.log.Loggable;

public interface FileHandler extends Loggable
{
    InputStream getInputStream(String p0);
    OutputStream getOutputStream(String p0);
    String append(String p0, String p1);
    String createDirectory(String p0, String p1);
    String createUniqueTmpDirectory();
    String getAbsolutePath(String p0);
    String getName(String p0);
    String getParent(String p0);
    String getTmpPath(String p0);
    String getURL(String p0);
    String readTextFile(String p0, Charset p1);
    String[] getChildren(String p0);
    String[] getChildren(String p0, List<String> p1);
    boolean exists(String p0);
    boolean isDirectory(String p0);
    boolean isDirectoryEmpty(String p0);
    long getSize(String p0);
    static String NEW_LINE = null;
    void copy(InputStream p0, OutputStream p1);
    void copy(InputStream p0, OutputStream p1, int p2);
    void copyDirectory(String p0, String p1);
    void copyDirectory(String p0, String p1, List<String> p2);
    void copyDirectory(String p0, String p1, Map<String, String> p2, Charset p3);
    void copyFile(String p0, String p1);
    void copyFile(String p0, String p1, Map<String, String> p2, Charset p3);
    void copyFile(String p0, String p1, boolean p2);
    void createFile(String p0);
    void delete(String p0);
    void explode(String p0, String p1);
    void mkdirs(String p0);
    void replaceInFile(String p0, Map<String, String> p1, Charset p2);
    void replaceInFile(String p0, Map<String, String> p1, Charset p2, boolean p3);
    void replaceInXmlFile(XmlReplacement... p0);
    void writeTextFile(String p0, String p1, Charset p2);
}
