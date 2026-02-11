// Generated automatically from org.apache.commons.compress.archivers.ArchiveStreamFactory for testing purposes

package org.apache.commons.compress.archivers;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Set;
import java.util.SortedMap;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveOutputStream;
import org.apache.commons.compress.archivers.ArchiveStreamProvider;

public class ArchiveStreamFactory implements ArchiveStreamProvider
{
    public ArchiveInputStream createArchiveInputStream(InputStream p0){ return null; }
    public ArchiveInputStream createArchiveInputStream(String p0, InputStream p1){ return null; }
    public ArchiveInputStream createArchiveInputStream(String p0, InputStream p1, String p2){ return null; }
    public ArchiveOutputStream createArchiveOutputStream(String p0, OutputStream p1){ return null; }
    public ArchiveOutputStream createArchiveOutputStream(String p0, OutputStream p1, String p2){ return null; }
    public ArchiveStreamFactory(){}
    public ArchiveStreamFactory(String p0){}
    public Set<String> getInputStreamArchiveNames(){ return null; }
    public Set<String> getOutputStreamArchiveNames(){ return null; }
    public SortedMap<String, ArchiveStreamProvider> getArchiveInputStreamProviders(){ return null; }
    public SortedMap<String, ArchiveStreamProvider> getArchiveOutputStreamProviders(){ return null; }
    public String getEntryEncoding(){ return null; }
    public static ArchiveStreamFactory DEFAULT = null;
    public static SortedMap<String, ArchiveStreamProvider> findAvailableArchiveInputStreamProviders(){ return null; }
    public static SortedMap<String, ArchiveStreamProvider> findAvailableArchiveOutputStreamProviders(){ return null; }
    public static String APK = null;
    public static String APKM = null;
    public static String APKS = null;
    public static String AR = null;
    public static String ARJ = null;
    public static String CPIO = null;
    public static String DUMP = null;
    public static String JAR = null;
    public static String SEVEN_Z = null;
    public static String TAR = null;
    public static String XAPK = null;
    public static String ZIP = null;
    public static String detect(InputStream p0){ return null; }
    public void setEntryEncoding(String p0){}
}
