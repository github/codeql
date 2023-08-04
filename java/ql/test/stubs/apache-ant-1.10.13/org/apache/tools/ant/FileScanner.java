// Generated automatically from org.apache.tools.ant.FileScanner for testing purposes

package org.apache.tools.ant;

import java.io.File;

public interface FileScanner
{
    File getBasedir();
    String[] getExcludedDirectories();
    String[] getExcludedFiles();
    String[] getIncludedDirectories();
    String[] getIncludedFiles();
    String[] getNotIncludedDirectories();
    String[] getNotIncludedFiles();
    void addDefaultExcludes();
    void scan();
    void setBasedir(File p0);
    void setBasedir(String p0);
    void setCaseSensitive(boolean p0);
    void setExcludes(String[] p0);
    void setIncludes(String[] p0);
}
