// Generated automatically from org.apache.commons.compress.archivers.ArchiveStreamProvider for testing purposes

package org.apache.commons.compress.archivers;

import java.io.InputStream;
import java.io.OutputStream;
import java.util.Set;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveOutputStream;

public interface ArchiveStreamProvider
{
    ArchiveInputStream createArchiveInputStream(String p0, InputStream p1, String p2);
    ArchiveOutputStream createArchiveOutputStream(String p0, OutputStream p1, String p2);
    Set<String> getInputStreamArchiveNames();
    Set<String> getOutputStreamArchiveNames();
}
