// Generated automatically from org.apache.commons.compress.compressors.CompressorStreamFactory for testing purposes

package org.apache.commons.compress.compressors;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Set;
import java.util.SortedMap;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.compressors.CompressorOutputStream;
import org.apache.commons.compress.compressors.CompressorStreamProvider;

public class CompressorStreamFactory implements CompressorStreamProvider
{
    public Boolean getDecompressUntilEOF(){ return null; }
    public CompressorInputStream createCompressorInputStream(InputStream p0){ return null; }
    public CompressorInputStream createCompressorInputStream(String p0, InputStream p1){ return null; }
    public CompressorInputStream createCompressorInputStream(String p0, InputStream p1, boolean p2){ return null; }
    public CompressorOutputStream createCompressorOutputStream(String p0, OutputStream p1){ return null; }
    public CompressorStreamFactory(){}
    public CompressorStreamFactory(boolean p0){}
    public CompressorStreamFactory(boolean p0, int p1){}
    public Set<String> getInputStreamCompressorNames(){ return null; }
    public Set<String> getOutputStreamCompressorNames(){ return null; }
    public SortedMap<String, CompressorStreamProvider> getCompressorInputStreamProviders(){ return null; }
    public SortedMap<String, CompressorStreamProvider> getCompressorOutputStreamProviders(){ return null; }
    public static CompressorStreamFactory getSingleton(){ return null; }
    public static SortedMap<String, CompressorStreamProvider> findAvailableCompressorInputStreamProviders(){ return null; }
    public static SortedMap<String, CompressorStreamProvider> findAvailableCompressorOutputStreamProviders(){ return null; }
    public static String BROTLI = null;
    public static String BZIP2 = null;
    public static String DEFLATE = null;
    public static String DEFLATE64 = null;
    public static String GZIP = null;
    public static String LZ4_BLOCK = null;
    public static String LZ4_FRAMED = null;
    public static String LZMA = null;
    public static String PACK200 = null;
    public static String SNAPPY_FRAMED = null;
    public static String SNAPPY_RAW = null;
    public static String XZ = null;
    public static String Z = null;
    public static String ZSTANDARD = null;
    public static String detect(InputStream p0){ return null; }
    public static String getBrotli(){ return null; }
    public static String getBzip2(){ return null; }
    public static String getDeflate(){ return null; }
    public static String getDeflate64(){ return null; }
    public static String getGzip(){ return null; }
    public static String getLZ4Block(){ return null; }
    public static String getLZ4Framed(){ return null; }
    public static String getLzma(){ return null; }
    public static String getPack200(){ return null; }
    public static String getSnappyFramed(){ return null; }
    public static String getSnappyRaw(){ return null; }
    public static String getXz(){ return null; }
    public static String getZ(){ return null; }
    public static String getZstandard(){ return null; }
    public void setDecompressConcatenated(boolean p0){}
}
