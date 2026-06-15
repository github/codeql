// Generated automatically from net.lingala.zip4j.ZipFile for testing purposes

package net.lingala.zip4j;

import java.io.Closeable;
import java.io.File;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadFactory;
import net.lingala.zip4j.io.inputstream.ZipInputStream;
import net.lingala.zip4j.model.FileHeader;
import net.lingala.zip4j.model.UnzipParameters;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.progress.ProgressMonitor;

public class ZipFile implements Closeable
{
    protected ZipFile() {}
    public Charset getCharset(){ return null; }
    public ExecutorService getExecutorService(){ return null; }
    public File getFile(){ return null; }
    public FileHeader getFileHeader(String p0){ return null; }
    public List<File> getSplitZipFiles(){ return null; }
    public List<FileHeader> getFileHeaders(){ return null; }
    public ProgressMonitor getProgressMonitor(){ return null; }
    public String getComment(){ return null; }
    public String toString(){ return null; }
    public ZipFile(File p0){}
    public ZipFile(File p0, char[] p1){}
    public ZipFile(String p0){}
    public ZipFile(String p0, char[] p1){}
    public ZipInputStream getInputStream(FileHeader p0){ return null; }
    public boolean isEncrypted(){ return false; }
    public boolean isRunInThread(){ return false; }
    public boolean isSplitArchive(){ return false; }
    public boolean isUseUtf8CharsetForPasswords(){ return false; }
    public boolean isValidZipFile(){ return false; }
    public int getBufferSize(){ return 0; }
    public void addFile(File p0){}
    public void addFile(File p0, ZipParameters p1){}
    public void addFile(String p0){}
    public void addFile(String p0, ZipParameters p1){}
    public void addFiles(List<File> p0){}
    public void addFiles(List<File> p0, ZipParameters p1){}
    public void addFolder(File p0){}
    public void addFolder(File p0, ZipParameters p1){}
    public void addStream(InputStream p0, ZipParameters p1){}
    public void close(){}
    public void createSplitZipFile(List<File> p0, ZipParameters p1, boolean p2, long p3){}
    public void createSplitZipFileFromFolder(File p0, ZipParameters p1, boolean p2, long p3){}
    public void extractAll(String p0){}
    public void extractAll(String p0, UnzipParameters p1){}
    public void extractFile(FileHeader p0, String p1){}
    public void extractFile(FileHeader p0, String p1, String p2){}
    public void extractFile(FileHeader p0, String p1, String p2, UnzipParameters p3){}
    public void extractFile(FileHeader p0, String p1, UnzipParameters p2){}
    public void extractFile(String p0, String p1){}
    public void extractFile(String p0, String p1, String p2){}
    public void extractFile(String p0, String p1, String p2, UnzipParameters p3){}
    public void extractFile(String p0, String p1, UnzipParameters p2){}
    public void mergeSplitFiles(File p0){}
    public void removeFile(FileHeader p0){}
    public void removeFile(String p0){}
    public void removeFiles(List<String> p0){}
    public void renameFile(FileHeader p0, String p1){}
    public void renameFile(String p0, String p1){}
    public void renameFiles(Map<String, String> p0){}
    public void setBufferSize(int p0){}
    public void setCharset(Charset p0){}
    public void setComment(String p0){}
    public void setPassword(char[] p0){}
    public void setRunInThread(boolean p0){}
    public void setThreadFactory(ThreadFactory p0){}
    public void setUseUtf8CharsetForPasswords(boolean p0){}
}
