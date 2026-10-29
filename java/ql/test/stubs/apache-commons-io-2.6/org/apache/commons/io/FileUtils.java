// Generated automatically from org.apache.commons.io.FileUtils for testing purposes

package org.apache.commons.io;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigInteger;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.CopyOption;
import java.nio.file.LinkOption;
import java.time.Instant;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.chrono.ChronoLocalDate;
import java.time.chrono.ChronoLocalDateTime;
import java.time.chrono.ChronoZonedDateTime;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Stream;
import java.util.zip.Checksum;
import org.apache.commons.io.LineIterator;
import org.apache.commons.io.filefilter.IOFileFilter;

public class FileUtils
{
    public FileUtils(){}
    public static BigInteger ONE_EB_BI = null;
    public static BigInteger ONE_GB_BI = null;
    public static BigInteger ONE_KB_BI = null;
    public static BigInteger ONE_MB_BI = null;
    public static BigInteger ONE_PB_BI = null;
    public static BigInteger ONE_TB_BI = null;
    public static BigInteger ONE_YB = null;
    public static BigInteger ONE_ZB = null;
    public static BigInteger sizeOfAsBigInteger(File p0){ return null; }
    public static BigInteger sizeOfDirectoryAsBigInteger(File p0){ return null; }
    public static Checksum checksum(File p0, Checksum p1){ return null; }
    public static Collection<File> listFiles(File p0, IOFileFilter p1, IOFileFilter p2){ return null; }
    public static Collection<File> listFiles(File p0, String[] p1, boolean p2){ return null; }
    public static Collection<File> listFilesAndDirs(File p0, IOFileFilter p1, IOFileFilter p2){ return null; }
    public static File createParentDirectories(File p0){ return null; }
    public static File delete(File p0){ return null; }
    public static File getFile(File p0, String... p1){ return null; }
    public static File getFile(String... p0){ return null; }
    public static File getTempDirectory(){ return null; }
    public static File getUserDirectory(){ return null; }
    public static File toFile(URL p0){ return null; }
    public static FileInputStream openInputStream(File p0){ return null; }
    public static FileOutputStream openOutputStream(File p0){ return null; }
    public static FileOutputStream openOutputStream(File p0, boolean p1){ return null; }
    public static File[] EMPTY_FILE_ARRAY = null;
    public static File[] convertFileCollectionToFileArray(Collection<File> p0){ return null; }
    public static File[] toFiles(URL... p0){ return null; }
    public static Iterator<File> iterateFiles(File p0, IOFileFilter p1, IOFileFilter p2){ return null; }
    public static Iterator<File> iterateFiles(File p0, String[] p1, boolean p2){ return null; }
    public static Iterator<File> iterateFilesAndDirs(File p0, IOFileFilter p1, IOFileFilter p2){ return null; }
    public static LineIterator lineIterator(File p0){ return null; }
    public static LineIterator lineIterator(File p0, String p1){ return null; }
    public static List<String> readLines(File p0){ return null; }
    public static List<String> readLines(File p0, Charset p1){ return null; }
    public static List<String> readLines(File p0, String p1){ return null; }
    public static Stream<File> streamFiles(File p0, boolean p1, String... p2){ return null; }
    public static String byteCountToDisplaySize(BigInteger p0){ return null; }
    public static String byteCountToDisplaySize(long p0){ return null; }
    public static String getTempDirectoryPath(){ return null; }
    public static String getUserDirectoryPath(){ return null; }
    public static String readFileToString(File p0){ return null; }
    public static String readFileToString(File p0, Charset p1){ return null; }
    public static String readFileToString(File p0, String p1){ return null; }
    public static URL[] toURLs(File... p0){ return null; }
    public static boolean contentEquals(File p0, File p1){ return false; }
    public static boolean contentEqualsIgnoreEOL(File p0, File p1, String p2){ return false; }
    public static boolean deleteQuietly(File p0){ return false; }
    public static boolean directoryContains(File p0, File p1){ return false; }
    public static boolean isDirectory(File p0, LinkOption... p1){ return false; }
    public static boolean isEmptyDirectory(File p0){ return false; }
    public static boolean isFileNewer(File p0, ChronoLocalDate p1){ return false; }
    public static boolean isFileNewer(File p0, ChronoLocalDate p1, LocalTime p2){ return false; }
    public static boolean isFileNewer(File p0, ChronoLocalDateTime<? extends Object> p1){ return false; }
    public static boolean isFileNewer(File p0, ChronoLocalDateTime<? extends Object> p1, ZoneId p2){ return false; }
    public static boolean isFileNewer(File p0, ChronoZonedDateTime<? extends Object> p1){ return false; }
    public static boolean isFileNewer(File p0, Date p1){ return false; }
    public static boolean isFileNewer(File p0, File p1){ return false; }
    public static boolean isFileNewer(File p0, Instant p1){ return false; }
    public static boolean isFileNewer(File p0, long p1){ return false; }
    public static boolean isFileOlder(File p0, ChronoLocalDate p1){ return false; }
    public static boolean isFileOlder(File p0, ChronoLocalDate p1, LocalTime p2){ return false; }
    public static boolean isFileOlder(File p0, ChronoLocalDateTime<? extends Object> p1){ return false; }
    public static boolean isFileOlder(File p0, ChronoLocalDateTime<? extends Object> p1, ZoneId p2){ return false; }
    public static boolean isFileOlder(File p0, ChronoZonedDateTime<? extends Object> p1){ return false; }
    public static boolean isFileOlder(File p0, Date p1){ return false; }
    public static boolean isFileOlder(File p0, File p1){ return false; }
    public static boolean isFileOlder(File p0, Instant p1){ return false; }
    public static boolean isFileOlder(File p0, long p1){ return false; }
    public static boolean isRegularFile(File p0, LinkOption... p1){ return false; }
    public static boolean isSymlink(File p0){ return false; }
    public static boolean waitFor(File p0, int p1){ return false; }
    public static byte[] readFileToByteArray(File p0){ return null; }
    public static long ONE_EB = 0;
    public static long ONE_GB = 0;
    public static long ONE_KB = 0;
    public static long ONE_MB = 0;
    public static long ONE_PB = 0;
    public static long ONE_TB = 0;
    public static long checksumCRC32(File p0){ return 0; }
    public static long copyFile(File p0, OutputStream p1){ return 0; }
    public static long lastModified(File p0){ return 0; }
    public static long lastModifiedUnchecked(File p0){ return 0; }
    public static long sizeOf(File p0){ return 0; }
    public static long sizeOfDirectory(File p0){ return 0; }
    public static void cleanDirectory(File p0){}
    public static void copyDirectory(File p0, File p1){}
    public static void copyDirectory(File p0, File p1, FileFilter p2){}
    public static void copyDirectory(File p0, File p1, FileFilter p2, boolean p3){}
    public static void copyDirectory(File p0, File p1, FileFilter p2, boolean p3, CopyOption... p4){}
    public static void copyDirectory(File p0, File p1, boolean p2){}
    public static void copyDirectoryToDirectory(File p0, File p1){}
    public static void copyFile(File p0, File p1){}
    public static void copyFile(File p0, File p1, CopyOption... p2){}
    public static void copyFile(File p0, File p1, boolean p2){}
    public static void copyFile(File p0, File p1, boolean p2, CopyOption... p3){}
    public static void copyFileToDirectory(File p0, File p1){}
    public static void copyFileToDirectory(File p0, File p1, boolean p2){}
    public static void copyInputStreamToFile(InputStream p0, File p1){}
    public static void copyToDirectory(File p0, File p1){}
    public static void copyToDirectory(Iterable<File> p0, File p1){}
    public static void copyToFile(InputStream p0, File p1){}
    public static void copyURLToFile(URL p0, File p1){}
    public static void copyURLToFile(URL p0, File p1, int p2, int p3){}
    public static void deleteDirectory(File p0){}
    public static void forceDelete(File p0){}
    public static void forceDeleteOnExit(File p0){}
    public static void forceMkdir(File p0){}
    public static void forceMkdirParent(File p0){}
    public static void moveDirectory(File p0, File p1){}
    public static void moveDirectoryToDirectory(File p0, File p1, boolean p2){}
    public static void moveFile(File p0, File p1){}
    public static void moveFile(File p0, File p1, CopyOption... p2){}
    public static void moveFileToDirectory(File p0, File p1, boolean p2){}
    public static void moveToDirectory(File p0, File p1, boolean p2){}
    public static void touch(File p0){}
    public static void write(File p0, CharSequence p1){}
    public static void write(File p0, CharSequence p1, Charset p2){}
    public static void write(File p0, CharSequence p1, Charset p2, boolean p3){}
    public static void write(File p0, CharSequence p1, String p2){}
    public static void write(File p0, CharSequence p1, String p2, boolean p3){}
    public static void write(File p0, CharSequence p1, boolean p2){}
    public static void writeByteArrayToFile(File p0, byte[] p1){}
    public static void writeByteArrayToFile(File p0, byte[] p1, boolean p2){}
    public static void writeByteArrayToFile(File p0, byte[] p1, int p2, int p3){}
    public static void writeByteArrayToFile(File p0, byte[] p1, int p2, int p3, boolean p4){}
    public static void writeLines(File p0, Collection<? extends Object> p1){}
    public static void writeLines(File p0, Collection<? extends Object> p1, String p2){}
    public static void writeLines(File p0, Collection<? extends Object> p1, String p2, boolean p3){}
    public static void writeLines(File p0, Collection<? extends Object> p1, boolean p2){}
    public static void writeLines(File p0, String p1, Collection<? extends Object> p2){}
    public static void writeLines(File p0, String p1, Collection<? extends Object> p2, String p3){}
    public static void writeLines(File p0, String p1, Collection<? extends Object> p2, String p3, boolean p4){}
    public static void writeLines(File p0, String p1, Collection<? extends Object> p2, boolean p3){}
    public static void writeStringToFile(File p0, String p1){}
    public static void writeStringToFile(File p0, String p1, Charset p2){}
    public static void writeStringToFile(File p0, String p1, Charset p2, boolean p3){}
    public static void writeStringToFile(File p0, String p1, String p2){}
    public static void writeStringToFile(File p0, String p1, String p2, boolean p3){}
    public static void writeStringToFile(File p0, String p1, boolean p2){}
}
