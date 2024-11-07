// Generated automatically from net.lingala.zip4j.io.inputstream.ZipInputStream for testing purposes

package net.lingala.zip4j.io.inputstream;

import java.io.InputStream;
import java.nio.charset.Charset;
import net.lingala.zip4j.model.FileHeader;
import net.lingala.zip4j.model.LocalFileHeader;
import net.lingala.zip4j.model.Zip4jConfig;
import net.lingala.zip4j.util.PasswordCallback;

public class ZipInputStream extends InputStream
{
    protected ZipInputStream() {}
    public LocalFileHeader getNextEntry(){ return null; }
    public LocalFileHeader getNextEntry(FileHeader p0, boolean p1){ return null; }
    public ZipInputStream(InputStream p0){}
    public ZipInputStream(InputStream p0, Charset p1){}
    public ZipInputStream(InputStream p0, PasswordCallback p1){}
    public ZipInputStream(InputStream p0, PasswordCallback p1, Charset p2){}
    public ZipInputStream(InputStream p0, PasswordCallback p1, Zip4jConfig p2){}
    public ZipInputStream(InputStream p0, char[] p1){}
    public ZipInputStream(InputStream p0, char[] p1, Charset p2){}
    public ZipInputStream(InputStream p0, char[] p1, Zip4jConfig p2){}
    public int available(){ return 0; }
    public int read(){ return 0; }
    public int read(byte[] p0){ return 0; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public void close(){}
    public void setPassword(char[] p0){}
}
