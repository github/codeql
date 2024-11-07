// Generated automatically from org.apache.commons.compress.compressors.CompressorStreamProvider for testing purposes

package org.apache.commons.compress.compressors;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Set;
import org.apache.commons.compress.compressors.CompressorInputStream;
import org.apache.commons.compress.compressors.CompressorOutputStream;

public interface CompressorStreamProvider
{
    CompressorInputStream createCompressorInputStream(String p0, InputStream p1, boolean p2);
    CompressorOutputStream createCompressorOutputStream(String p0, OutputStream p1);
    Set<String> getInputStreamCompressorNames();
    Set<String> getOutputStreamCompressorNames();
}
