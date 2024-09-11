// Generated automatically from org.apache.commons.compress.archivers.jar.JarArchiveInputStream for testing purposes

package org.apache.commons.compress.archivers.jar;

import java.io.InputStream;
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.jar.JarArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;

public class JarArchiveInputStream extends ZipArchiveInputStream
{
    protected JarArchiveInputStream() {}
    public ArchiveEntry getNextEntry(){ return null; }
    public JarArchiveEntry getNextJarEntry(){ return null; }
    public JarArchiveInputStream(InputStream p0){}
    public JarArchiveInputStream(InputStream p0, String p1){}
    public static boolean matches(byte[] p0, int p1){ return false; }
}
